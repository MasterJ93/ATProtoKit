# Configuring and Implementing Sessions

Choose a built-in authentication configuration or implement ATProtoKit's request-time session contract.

## Overview

``SessionConfiguration`` is the common request-time contract used by ATProtoKit. It identifies a session, configures networking, exposes the current account context, and authorizes requests. It does not require every conforming type to implement account creation, token refresh, credential storage, or session deletion.

Those lifecycle operations are separated into capability protocols for App Password and OAuth sessions. Most applications should construct ``ATProtocolConfiguration`` or ``ATOAuthSessionConfiguration`` instead of implementing the protocols directly.

## Choose the appropriate configuration

Use ``ATProtocolConfiguration`` for App Password authentication. It provides the complete built-in App Password lifecycle:

- authenticating with a handle and App Password;
- accepting multi-factor authentication codes;
- keeping the short-lived access token in configuration memory;
- persisting the App Password and rotating refresh token through ``ATCredentialStore``;
- refreshing authorization before authenticated requests;
- registering the public ``UserSession`` context; and
- deleting the remote session and locally stored credentials.

Use ``ATOAuthSessionConfiguration`` when an external OAuth package owns authorization. ATProtoKit does not implement identity verification, authorization-server discovery, PAR, PKCE, DPoP, OAuth token persistence, refresh, or nonce retries. The OAuth package supplies the visible account context and executes complete requests through an ``ATRequestExecutor``. See <doc:OAuthIntegration> for that integration pattern.

OAuth permission scopes are also selected in the external OAuth package's authorization request, not on `SessionConfiguration` or `ATOAuthSessionConfiguration`. The resulting ``SessionAuthorizationContext`` records the exact scopes returned by the authorization server; it does not request or expand them. See <doc:OAuthIntegration> for requesting additional scopes and upgrading an existing session.

## Understand the core contract

``SessionConfiguration`` inherits from `Sendable`, ``ATRequestAuthenticator``, and `AnyObject`. Consequently, a conformer must be a concurrency-safe reference type, but the protocol does not specifically require a `final` `class`. A `final` `class` with immutable sendable state or an actor are common implementation choices.

The protocol requires:

- `pdsURL`, the bootstrap Personal Data Server (PDS) URL;
- `configuration`, the `URLSessionConfiguration` used by ATProtoKit;
- `instanceUUID`, the identifier used with ``UserSessionRegistry``; and
- ``SessionConfiguration/authorization(for:)``, which supplies header-based authorization.

It also offers these request-time extension points:

- ``SessionConfiguration/requestExecutor`` defaults to `nil`;
- ``SessionConfiguration/requestExecutorOwnsAuthorization`` defaults to `false`;
- ``ATRequestAuthenticator/authenticatedRequest(for:authorizationRequirement:)`` applies the value
  returned by `authorization(for:)` only to requests marked as requiring a session; and
- ``SessionConfiguration/authorizationContext()`` defaults to deriving a context from the
  ``UserSession`` registered under `instanceUUID`.

The `pdsURL` property is a bootstrap value and does not change when a session is registered. Code that constructs an ATProtoKit client manually after loading a dynamic context must pass the registered context's `serviceEndpoint`. ``ATProtoKit/createOAuthSession(sessionConfiguration:apiClientConfiguration:canUseBlueskyRecords:)`` does this automatically for ``ATOAuthSessionConfiguration``.

## Add lifecycle capabilities deliberately

Conform to focused capability protocols only when the custom type owns their behavior:

- ``UserSessionRegistryManaging`` adds session registration and removal;
- ``AppPasswordCredentialStoring`` adds an ``ATCredentialStore`` for the App Password and refresh
  token;
- ``AppPasswordAuthenticating`` adds App Password authentication, in-memory access-token caching,
  refresh, request-time validation, and authentication-factor input;
- ``ATAccountCreating`` adds account creation;
- ``AppPasswordSessionManaging`` combines all built-in App Password lifecycle capabilities; and
- ``OAuthSessionSynchronizing`` reloads context owned by an external OAuth implementation.

The default implementations for App Password authentication and lifecycle operations are defined on these App Password capability protocols, not on `SessionConfiguration` itself. A custom `SessionConfiguration` does not acquire those operations automatically.

## Configure App Password persistence

``ATCredentialStore`` is an opaque, persistent data store. ``ATProtocolConfiguration`` writes only the App Password and refresh token to it. The access token is intentionally held by the configuration's actor-backed memory cache and is replaced whenever the session refreshes.

On Apple platforms, ``AppleSecureKeychain`` is the default store. To restore an App Password session in a later process, persist the configuration's session identifier with the application's account metadata, recreate the configuration with that identifier, and call ``UserSessionRegistryManaging/registerSession()``:

```swift
let secureStore = AppleSecureKeychain(
    serviceName: "com.example.app.credentials"
)
let configuration = ATProtocolConfiguration(
    credentialStore: secureStore,
    sessionIdentifier: persistedAccountIdentifier
)

try await configuration.registerSession()
let client = await ATProtoKit(
    sessionConfiguration: configuration,
    pdsURL: configuration.pdsURL
)
```

The recreated configuration starts without an access token. Registration refreshes from the persisted refresh token, caches the new access token, loads the server's current session, and registers its public context. If no refresh token exists, or the session can no longer be refreshed, the application must authenticate again.

Use a different stable identifier for each App Password account. ATProtoKit builds its internal keys from that identifier, so changing it makes the previously stored credentials inaccessible to the new configuration.

Applications can supply a custom backend through the same initializer:

```swift
let configuration = ATProtocolConfiguration(
    credentialStore: customCredentialStore,
    sessionIdentifier: persistedAccountIdentifier
)
```

Linux and Windows applications must currently provide their own ``ATCredentialStore``. An OAuth persistence adapter may also choose to use the same backend under separate app-owned keys, but ATProtoKit does not automatically store OAuth sessions in `ATCredentialStore`. See <doc:CredentialStorageMigration> for storage compatibility and migration details.

## Select a PDS before App Password authentication

``ATProtocolConfiguration`` sends App Password authentication to its configured `pdsURL`, which defaults to `https://bsky.social`. If the application verifies a handle and discovers another PDS before authentication, construct the configuration with that origin:

```swift
let verifiedIdentity = try await identityResolver.resolveVerifiedIdentity(
    handle: enteredHandle
)
let configuration = ATProtocolConfiguration(
    pdsURL: verifiedIdentity.pdsURL.absoluteString,
    credentialStore: secureStore,
    sessionIdentifier: persistedAccountIdentifier
)

try await configuration.authenticate(
    with: verifiedIdentity.handle,
    password: appPassword
)
let client = await ATProtoKit(
    sessionConfiguration: configuration,
    pdsURL: configuration.pdsURL
)
```

The identity resolver and its method names in this example represent an application-selected identity package. The application remains responsible for verifying that the handle, DID, and PDS relationship is trustworthy before sending credentials to the discovered service.

## Implement header-based authorization

A custom configuration is appropriate for an authentication mechanism that can authorize the final request with headers and does not require OAuth's DPoP nonce and retry ownership. The configuration returns a ``SessionAuthorization`` value; ATProtoKit applies it only when the method marks the request as requiring a session.

```swift
public actor ApplicationTokenStore {

    private var token: String

    public init(token: String) {
        self.token = token
    }

    public func currentToken() -> String {
        return token
    }
}

public final class ApplicationSessionConfiguration: SessionConfiguration {

    public let pdsURL: String

    public let configuration: URLSessionConfiguration

    public let instanceUUID: UUID

    private let tokenStore: ApplicationTokenStore

    public init(
        pdsURL: String,
        instanceUUID: UUID,
        tokenStore: ApplicationTokenStore
    ) {
        self.pdsURL = pdsURL
        self.configuration = .default
        self.instanceUUID = instanceUUID
        self.tokenStore = tokenStore
    }

    public func authorization(
        for request: URLRequest
    ) async throws -> SessionAuthorization? {
        return .bearer(await tokenStore.currentToken())
    }
}
```

Register the corresponding ``UserSession`` under the same `instanceUUID` before calling APIs that need the active account's DID or service endpoint. Alternatively, conform the custom configuration to ``UserSessionRegistryManaging`` and implement that lifecycle within the type.

- Note: Do not use this header-only pattern for OAuth. OAuth request execution must remain with the OAuth package so it can create a DPoP proof for the final method and URL, respond to nonce challenges, rotate tokens, and retry safely.
