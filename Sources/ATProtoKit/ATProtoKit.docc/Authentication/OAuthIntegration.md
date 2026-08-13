# Integrating OAuth in the AT Protocol

Connect an OAuth implementation to ATProtoKit without giving up DPoP-aware request handling.

@Metadata {
    @PageColor(blue)
}

## Overview

ATProtoKit provides the XRPC client surface but does not implement the AT Protocol OAuth flow. Use an OAuth package to own identity resolution, server metadata discovery, pushed authorization requests (PAR), PKCE, DPoP keys and nonces, token persistence, refresh token rotation, and retries. Connect that package through ``ATOAuthSessionConfiguration``.

The OAuth package must send authenticated requests itself. A DPoP proof is bound to the final HTTP method and URL, and a server can require a fresh nonce. For that reason, copying an access token or a precomputed `DPoP` header into ATProtoKit is not sufficient.

## Persist through a shared secure backend

``ATCredentialStore`` can be the common secure value backend for App Password and OAuth persistence. It stores opaque data and deliberately knows nothing about OAuth models. App Password sessions use it directly for their password and refresh token, while their access token remains in-memory. OAuth sessions use it only when the application's OAuth persistence adapter chooses to do so. On Apple platforms, ``AppleSecureKeychain`` is the included persistent implementation.

An app can therefore pass one Keychain backend to its OAuth-specific persistence adapter:

```swift
let secureStore = AppleSecureKeychain(
    serviceName: "com.example.app.credentials"
)

let oauthSessionStore = ExampleOAuthSessionStore(secureStore: secureStore)
```

The same backend can be used for an App Password account. Persist the account identifier outside the credential store and reuse it when recreating the configuration:

```swift
let appPasswordConfiguration = ATProtocolConfiguration(
    credentialStore: secureStore,
    sessionIdentifier: persistedAccountIdentifier
)
```

The OAuth adapter must use its own stable keys, while `ATProtocolConfiguration` namespaces App Password values with `sessionIdentifier`. Sharing the backend therefore does not combine their credential models or make OAuth persistence automatic.

The adapter remains responsible for encoding the OAuth package's complete restorable session, including its tokens and DPoP key. ATProtoKit does not prescribe that model, import the OAuth package, or store only part of the session.

## Create the bridge

Adapt the OAuth package's request operation with ``ClosureATRequestExecutor``. The executor receives the completed request body and an ``ATRequestAuthorizationRequirement`` value that distinguishes public requests from requests requiring the active session.

```swift
let publicSession = URLSession(configuration: .default)
let executor = ClosureATRequestExecutor { request, requirement in
    switch requirement {
    case .none:
        return try await publicSession.data(for: request)
    case .session:
        return try await oauthClient.sendAuthorizedRequest(request)
    }
}

let configuration = ATOAuthSessionConfiguration(
    pdsURL: restoredSession.pdsURL.absoluteString,
    requestExecutor: executor,
    contextProvider: {
        return SessionAuthorizationContext(
            sessionDID: restoredSession.accountDID,
            handle: restoredSession.handle,
            serviceEndpoint: restoredSession.pdsURL,
            grantedScopes: restoredSession.grantedScopes
        )
    },
    refreshHandler: {
        let refreshedSession = try await oauthClient.refreshSession()
        return SessionAuthorizationContext(
            sessionDID: refreshedSession.accountDID,
            handle: refreshedSession.handle,
            serviceEndpoint: refreshedSession.pdsURL,
            grantedScopes: refreshedSession.grantedScopes
        )
    },
    deletionHandler: {
        try await oauthClient.deleteSession()
    }
)
```

The names on `oauthClient` and the restored session in this example are placeholders. Map them to the API of the OAuth package selected by the application. The `.none` branch must remain unauthenticated. The `.session` branch must let the OAuth package apply current tokens and DPoP proofs, handle nonce challenges, refresh when necessary, and retry the final request.

An OAuth configuration's executor owns both authorization and transport. If an ``APIClientConfiguration`` passed to `ATProtoKit` also contains a response provider or request authenticator, ATProtoKit keeps the OAuth executor and does not replace or layer authorization over it.

### Use a fixed context

When the identity, Personal Data Server (PDS) endpoint, and granted scopes remain fixed for the lifetime of the configuration, pass an already-created ``SessionAuthorizationContext``. This initializer derives the bootstrap PDS URL from the context and supplies the context provider internally.

```swift
let context = SessionAuthorizationContext(
    sessionDID: authorizedSession.accountDID,
    handle: authorizedSession.handle,
    serviceEndpoint: authorizedSession.pdsURL,
    grantedScopes: authorizedSession.grantedScopes
)

let configuration = ATOAuthSessionConfiguration(
    context: context,
    requestExecutor: executor,
    deletionHandler: {
        try await oauthClient.deleteSession()
    }
)
```

Use the provider-based initializer instead when the visible identity, endpoint, or exact scope set can change while the configuration remains alive. Neither initializer depends on a particular OAuth package.

## Register a restored or newly authorized session

Call ``ATOAuthSessionConfiguration/registerSession()`` after authorization or restoration and before using authenticated ATProtoKit methods. Registration validates and publishes the account decentralized identifier (DID) and provider-supplied PDS endpoint. ``ATProtoKit/createOAuthSession(sessionConfiguration:apiClientConfiguration:canUseBlueskyRecords:)`` performs registration and client construction as one checked operation:

```swift
let client = try await ATProtoKit.createOAuthSession(
    sessionConfiguration: configuration
)
let timeline = try await client.getTimeline()
```

The equivalent explicit sequence remains available when an application needs to perform work between registration and client construction:

```swift
try await configuration.registerSession()
let registeredContext = try await configuration.authorizationContext()
let registeredPDSURL = registeredContext?.serviceEndpoint.absoluteString
    ?? configuration.pdsURL
let client = await ATProtoKit(
    sessionConfiguration: configuration,
    pdsURL: registeredPDSURL
)
```

Use the registered context's endpoint when constructing the client manually. The `pdsURL` passed to the provider-based initializer is only the bootstrap value used before a context is loaded; it does not change when a different context is registered.

Registration and explicit synchronization validate the supplied context. A valid context must contain:

- a syntactically valid DID;
- an HTTPS PDS origin without credentials, a path prefix, a query, or a fragment;
- the mandatory `atproto` scope.

Invalid contexts throw ``ATOAuthSessionConfigurationError`` and are not placed in ``UserSessionRegistry``.

## Check granted permissions

The token response's complete `scope` value should be passed to ``SessionAuthorizationContext/init(sessionDID:handle:serviceEndpoint:grantedScopes:)``. Before presenting or starting a feature, the application can check its required scopes:

```swift
guard let context = try await configuration.authorizationContext() else {
    return // Treat the absent context as a signed-out session.
}
try context.requireGrantedScopes([
    "repo:app.bsky.feed.post",
    "blob:image/*"
])
```

``SessionAuthorizationContext/hasGrantedScope(_:)`` and ``SessionAuthorizationContext/missingGrantedScopes(from:)`` use exact string comparison. They do not expand permission wildcards or permission-set references. This preserves the authorization server's interpretation and avoids claiming a permission the server did not explicitly return.

## Present authorization

The OAuth package is responsible for presenting its authorization URL and receiving the redirect. ATProtoKit doesn't import platform authentication frameworks or provide a browser presentation abstraction. This keeps presentation, callback routing, and the protocol state that protects the flow under one owner.

The OAuth package must validate the callback's `state` and `iss` values, exchange the authorization code, check the token response's `sub` and `scope`, and persist the resulting session. After that work completes, pass the session context and OAuth-aware request executor to ``ATOAuthSessionConfiguration``.

## Refresh and deletion

Normal authenticated requests should allow the OAuth executor to refresh and retry as required by the server. That request-time work does not automatically update the identity and PDS context cached by ATProtoKit. Call ``ATOAuthSessionConfiguration/synchronizeSession()`` when the externally owned session context may have changed. When a `refreshHandler` is supplied, synchronization uses the context returned by that handler. Without one, synchronization reloads the context from `contextProvider`. In either case, ATProtoKit validates and registers the returned context.

``ATOAuthSessionConfiguration/removeSession()`` invokes the configured deletion operation and then clears the cached context and local ATProtoKit registry entry. If the deletion operation throws, the local context and registry entry remain intact. The OAuth package decides whether deletion only removes local credentials or also revokes tokens at the authorization server.

- Note: For protocol requirements, see the [AT Protocol OAuth specification](https://atproto.com/specs/oauth) and [Permissions specification](https://atproto.com/specs/permission).
