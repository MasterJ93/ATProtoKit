# Migrating Credential Storage

Migrate App Password credential handling from `SecureKeychainProtocol` in version 0.33.3 to
`ATCredentialStore` in ATProtoKit 0.34.0.

@Metadata {
    @PageColor(blue)
}

## Overview

- Warning: Version 0.34.0 is a source-breaking update. The keychain compatibility declarations that appeared in intermediate development commits were removed before 0.34.0 rather than shipped as deprecated API.

ATProtoKit 0.34.0 separates three responsibilities that the previous credential interface combined:

- ``ATCredentialStore`` provides persistent storage for opaque `Data` values;
- ``ATProtocolConfiguration`` owns the stable session identifier and its short-lived, in-memory access token; and
- the App Password session capability manages authentication, token refresh, and the storage keys for the App Password and refresh token.

The removed `SecureKeychainProtocol` exposed individual password, access token, and refresh token operations and required every store to own an account identifier. Its name also implied Apple Keychain even when an application used another protected backend.

The replacement protocol has only three operations: load, save, and delete. Callers own their value formats and key namespaces; conforming stores own secure persistence. The same boundary can therefore support App Password data and an OAuth library's encoded session without coupling either model to the backend.

## Replace Removed Declarations

Update code written against 0.33.3 as follows:

| Removed declaration | Current API |
| ------------------- | ----------- |
| `SecureKeychainProtocol` | ``ATCredentialStore`` |
| `ATProtocolConfiguration.keychainProtocol` | ``ATProtocolConfiguration/credentialStore`` |
| `init(pdsURL:keychainProtocol:configuration:canResolve:)` | ``ATProtocolConfiguration/init(pdsURL:credentialStore:sessionIdentifier:configuration:canResolve:)`` |
| `SecureKeychainProtocol.identifier` | the `sessionIdentifier` initializer argument and ``ATProtocolConfiguration/instanceUUID`` |

The former token-specific methods do not have one-to-one public replacements. For ordinary App Password sessions, ``ATProtocolConfiguration`` automatically caches the access token and reads or writes the App Password and refresh token through its store. Applications access ``ATCredentialStore/loadValue(forKey:)``, ``ATCredentialStore/saveValue(_:forKey:)``, and ``ATCredentialStore/deleteValue(forKey:)`` directly only when they own the stored value and its key.

The access token-related cache operations (``ATProtocolConfiguration/cacheAccessToken(_:)``, ``ATProtocolConfiguration/cachedAccessToken()``, and ``ATProtocolConfiguration/clearCachedAccessToken()``) primarily support custom ``AppPasswordAuthenticating`` implementations. Applications using the built-in lifecycle generally do not call them.

## Migrate ATProtocolConfiguration

Previously, the credential implementation supplied the UUID used to associate a visible session with its stored values:

```swift
let identifier = persistedAccountIdentifier
let keychain = AppleSecureKeychain(
    identifier: identifier,
    serviceName: "com.example.app.credentials"
)
let configuration = ATProtocolConfiguration(keychainProtocol: keychain)
```

Now, supply the persistent backend and session identifier separately:

```swift
let credentialStore = AppleSecureKeychain(
    serviceName: "com.example.app.credentials"
)
let configuration = ATProtocolConfiguration(
    credentialStore: credentialStore,
    sessionIdentifier: persistedAccountIdentifier
)
```

Persist a separate session identifier with each account's application metadata and reuse it whenever the configuration is rebuilt. The initializer creates a new UUID by default, which is appropriate for a new account session but cannot locate credentials stored under a previous identifier.

On non-Apple platforms, the initializer requires an ``ATCredentialStore`` because ATProtoKit does not provide a default protected-storage backend there.

## Preserve Existing Apple Keychain Values

The built-in migration preserves the 0.33.3 Keychain namespace for persistent App Password data:

| Value | Keychain account key |
| ----- | -------------------- |
| App Password | `<session UUID>.password` |
| Refresh token | `<session UUID>.refreshToken` |

Reuse both the old `SecureKeychainProtocol.identifier` value as `sessionIdentifier` and the old `AppleSecureKeychain.serviceName`. The default service name remains `ATProtoKit`. With both values preserved, the new configuration reads the existing App Password and refresh token without copying or rewriting them.

If the former identifier is unavailable, authenticate again. Generating a new UUID cannot locate the old entries. If a custom 0.33.3 implementation transformed keys or used another namespace, preserve that behavior inside its new ``ATCredentialStore`` implementation.

``AppleSecureKeychain`` now stores opaque generic password data and uses an "after first unlock," device-only accessibility policy. Saving an existing item updates it to this policy. Values remain available to background refresh after the first device unlock and do not migrate through backups or synchronized Keychain.

## Understand the Access Token Lifecycle

App Password access tokens remain memory-only, matching the behavior of `AppleSecureKeychain` in version 0.33.3. No `<session UUID>.accessToken` value is written to ``ATCredentialStore``.

``ATProtocolConfiguration`` manages the token automatically:

- account creation and authentication cache the access token returned by the server;
- authenticated requests inspect the cached token's expiration with a 10-second safety margin;
- refresh replaces the cached access token and persists the rotated refresh token;
- a configuration recreated after launch starts with an empty access token cache and exchanges its persisted refresh token for a new access token before an authenticated request; and
- successful session removal clears the access token cache and deletes the persisted App Password and refresh token.

A custom 0.33.3 store might have persisted its access token even though the built-in Apple store did not. ATProtoKit 0.34.0 does not read that value. The application can remove it as part of its custom migration.

## Update a Custom Persistent Store

A previous implementation modeled every App Password value separately:

```swift
public actor ApplicationKeychain: SecureKeychainProtocol {
    public nonisolated let identifier: UUID

    // Individual password and token operations...
}
```

Replace it with an opaque persistent backend:

```swift
public actor ApplicationCredentialStore: ATCredentialStore {
    private let protectedVault: ApplicationProtectedVault

    public init(protectedVault: ApplicationProtectedVault) {
        self.protectedVault = protectedVault
    }

    public func loadValue(forKey key: String) async throws -> Data? {
        return try await protectedVault.loadValue(forKey: key)
    }

    public func saveValue(_ value: Data, forKey key: String) async throws {
        try await protectedVault.saveValue(value, forKey: key)
    }

    public func deleteValue(forKey key: String) async throws {
        try await protectedVault.deleteValue(forKey: key)
    }
}
```

The backend should:

- treat keys and values as opaque;
- preserve values when the store object is recreated;
- replace an existing value when saving under the same key;
- treat deletion of a missing value as success; and
- provide the confidentiality and device-access policy appropriate to the application.

The store no longer owns a session UUID or implements an access token cache. Supply account identity to ``ATProtocolConfiguration`` and let that configuration keep its access token in memory.

If an application implements ``AppPasswordAuthenticating`` itself rather than using ``ATProtocolConfiguration``, it must also implement `cacheAccessToken(_:)`, `cachedAccessToken()`, and `clearCachedAccessToken()`. Back those operations with isolated in-memory state, such as an actor. Do not forward them to ``ATCredentialStore``. The default App Password lifecycle calls these operations during authentication, refresh, request authorization, and session removal.

## Update Error Handling

``ATCredentialStoreError`` reports backend-independent decoding and missing-value errors used by the App Password helpers. ``ApplSecureKeychainError`` reports missing items, invalid Keychain data, and Security framework status failures when the Apple backend is used directly.

The unused `ATKeychainError` and the intermediate `SecureCredentialStoreError` name are not part of the current API. Custom stores may define and throw their own concrete error types.

## Share a Store with OAuth

``ATCredentialStore`` does not define an OAuth session schema. An OAuth implementation remains responsible for encoding all state required to restore its session—including tokens and its DPoP key—and for revalidating that state after loading it. Store the encoded session under an app-owned key that cannot collide with the App Password keys:

```swift
let sessionData = try JSONEncoder().encode(oauthSession)
try await credentialStore.saveValue(
    sessionData,
    forKey: "oauth.current-session"
)
```

See <doc:OAuthIntegration> for OAuth session lifecycle and transport integration.
