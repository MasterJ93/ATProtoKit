# Walkthrough: Implementing OAuth into a macOS App

Learn how to add AT Protocol-flavoured OAuth using ATProtoKit, ATIdentityTools, and other libraries.

@Metadata {
    @PageColor(blue)
}

## Overview

This tutorial explains step by step how to add OAuth into an app. By the end, you'll be able to:

- accept an AT Protocol handle,
- open the account's authorization page,
- authenticate with AT Protocol-flavoured OAuth and DPoP,
- persist or refresh that session after relaunch,
- make an authenticated `com.atproto.server.getSession` request through ATProtoKit, and
- sign out and remove the persisted session.

For this tutorial, we will name it "OAuthCheck."

## Starting the tutorial

### 1. Set up the project

This tutorial starts with a newly created Xcode project, using the "App" template.

Create one by opening Xcode, then going to **File > New > Project...**, then selecting **macOS > App**. For this tutorial, we'll be using SwiftUI. Name it "OAuthCheck" and click **Next**.

Once you select where to save the project, click **Create**. Once Xcode opens the newly-created project, head over to **File > Add Package Dependencies**. Add the latest versions of:

- ATProtoKit,
- ATIdentityTools,
- [OAuthenticator](https://github.com/ChimeHQ/OAuthenticator), and
- [Jot](https://github.com/mattmassicotte/Jot).

### 2. Review the Client Metadata JSON

AT Protocol accounts can be hosted by different servers. Your app therefore needs public client
metadata that tells those servers what the app is called, where they can send the user after
sign-in, and which parts of OAuth the app supports.

This tutorial uses Ceupost's published [client metadata](https://masterj93.github.io/bluesky-oauth/ceupost/client-metadata.json):

```json
{
  "client_id": "https://masterj93.github.io/bluesky-oauth/ceupost/client-metadata.json",
  "application_type": "native",
  "client_name": "Ceupost",
  "redirect_uris": [
    "io.github.masterj93:/oauth/callback"
  ],
  "grant_types": [
    "authorization_code",
    "refresh_token"
  ],
  "response_types": [
    "code"
  ],
  "scope": "atproto include:app.bsky.authCreatePosts?aud=did:web:api.bsky.app%23bsky_appview repo:app.bsky.feed.post?action=delete repo:app.bsky.feed.postgate?action=delete repo:app.bsky.feed.threadgate?action=delete blob?accept=image/*&accept=video/*",
  "token_endpoint_auth_method": "none",
  "dpop_bound_access_tokens": true
}
```

The controller will request only `atproto`, which is included in the metadata's declared scope. The
`client_id` and redirect URI copied into the app must match these published values exactly. A
production app should publish its own metadata instead of identifying itself as Ceupost.

### 3. Register the redirect URL with macOS

In Xcode:

1. Select the project.
2. Select the macOS app target.
3. Open the **Info** tab.
4. Expand **URL Types**.
5. Select the **+** button.
6. Enter an identifier as "OAuthCheck OAuth Callback."
7. Enter `io.github.masterj93` under **URL Schemes**.

- Note: Do not enter the complete callback URL in the URL Schemes field. macOS registers the scheme and passes the complete callback URL to the active authentication session.

### 4. Allow network access

In the app target's **Signing & Capabilities** tab:

1. Add **App Sandbox** if it is not already present.
2. Under **Network**, enable **Outgoing Connections (Client)**.

- Note: Without this entitlement, identity resolution, metadata discovery, token exchange, and XRPC calls
can fail even though the code is correct.

For this tutorial, we won't need to enable Keychain Sharing, so we can leave that alone.

### 5. Add the persistent OAuth session store

We're now at the part where we're writing code. Let's add a `struct` that handles the OAuth session.

Create a new file inside of the **OAuthCheck** folder by right-clicking and selecting **New Empty File**. Name it "PersistedOAuthSession.swift."

Import `Foundation`, `ATProtoKit`, `ATIdentityTools`, and `OAuthenticator`:

```swift
import Foundation
import ATProtoKit
import ATIdentityTools
import OAuthenticator
```

Then create a `struct` named `PersistedOAuthSession`:

```swift
public nonisolated struct PersistedOAuthSession: Codable, Sendable {

    public let login: Login

    public let dpopKey: DPoPKey

    public let handle: String

    public let did: String

    public let pds: URL

    public let issuer: String

    public nonisolated init(
        login: Login,
        dpopKey: DPoPKey,
        handle: String,
        did: String,
        pds: URL,
        issuer: String
    ) {
        self.login = login
        self.dpopKey = dpopKey
        self.handle = handle
        self.did = did
        self.pds = pds
        self.issuer = issuer
    }
}
```

This represents the OAuth session itself. `Login` and `DPoPKey` are both owned by OAuthenticator. If you have your own custom OAuth package, it should have `struct`s that have a similar responsibility.

Now, we need a way to check if the saved session belongs to the freshly verified login destination. Create a new method inside of `PersistedOAuthSession`,  called `matches(identity:issuer:)`:

```swift
public nonisolated func matches(identity: VerifiedIdentity, issuer: String) -> Bool {
    return self.did == identity.did
        && self.pds == identity.pds
        && self.issuer == issuer
}
```

This method returns `Bool`, to simply tell us if the session within `VerifiedIdentity` is the same as the one stored in this `PersistedOAuthSession` instance.

We'll need a type that persists the complete OAuth account. Below `PersistedOAuthSession`, create an `actor` named `OAuthSessionStore`:

```swift
public actor OAuthSessionStore<Store> where Store: ATCredentialStore {

    private let secureStore: Store

    private let storageKey = "atproto-oauth-session"

    public init(secureStore: Store) {
        self.secureStore = secureStore
    }
}
```

`Store` can be any type that conforms to `ATCredentialStore`. Later on, we'll use ATProtoKit's `AppleSecureKeychain`. The `storageKey` is the name used to find this particular value in the Keychain.

First, add a method that loads the saved session. Place it inside `OAuthSessionStore`:

```swift
public func load() async throws -> PersistedOAuthSession? {
    guard let data = try await secureStore.loadValue(forKey: storageKey) else {
        return nil
    }

    return try JSONDecoder().decode(PersistedOAuthSession.self, from: data)
}
```

Since `data` is a `Data` object, we'll use `JSONDecoder` so it changes it back into `PersistedOAuthSession`. If there is no value under `storageKey`, the method returns `nil`.

Next, add the method that saves a session:

```swift
public func save(_ session: PersistedOAuthSession) async throws {
    let data = try JSONEncoder().encode(session)
    try await secureStore.saveValue(data, forKey: storageKey)
}
```

This does the reverse of `load()`: it first encodes the session as a `Data` object, then asks the secure store to save it.

Finally, add a way to remove the session:

```swift
public func delete() async throws {
    try await secureStore.deleteValue(forKey: storageKey)
}
```

We'll call `delete()` when the user signs out, and OAuthenticator will also use it if a saved login can no longer be refreshed.

### 6. Present the authorization page

Create another Swift file named "OAuthController.swift." This file will coordinate the rest of the sign-in process.

Start by importing the packages we'll use:

```swift
import Foundation
import AuthenticationServices
import Combine
import CryptoKit
import ATProtoKit
import ATIdentityTools
import Jot
import OAuthenticator
```

`AuthenticationServices` presents the sign-in page. `Combine` supplies `ObservableObject` and `@Published`, while `CryptoKit` and Jot will create the DPoP proof.

- Note: ATProtoKit comes with a convenience `enum`, named ``OAuthError``. You can use this for this tutorial, or you can create your own if you want things done a different way.

Now add a function that handles the result from `AuthenticationServices`:

```swift
private nonisolated func makeAuthenticationCompletionHandler(
    continuation: CheckedContinuation<URL, Error>,
    contextProvider: CredentialWindowProvider
) -> (URL?, Error?) -> Void {
    return { callbackURL, error in
        withExtendedLifetime(contextProvider) {}

        if let error {
            continuation.resume(throwing: error)
        } else if let callbackURL {
            continuation.resume(returning: callbackURL)
        } else {
            continuation.resume(throwing: OAuthError.invalidAuthenticationCallback)
        }
    }
}
```

Below that function, add another function which creates the authorization window:

```swift
@MainActor
private func authenticateUser(
    at url: URL,
    callbackURLScheme: String
) async throws -> URL {
    return try await withCheckedThrowingContinuation { continuation in
        let contextProvider = CredentialWindowProvider()
        let completionHandler = makeAuthenticationCompletionHandler(
            continuation: continuation,
            contextProvider: contextProvider
        )
        let session = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: callbackURLScheme,
            completionHandler: completionHandler
        )
        session.prefersEphemeralWebBrowserSession = true
        session.presentationContextProvider = contextProvider

        guard session.start() else {
            continuation.resume(throwing: OAuthError.authenticationSessionFailedToStart)
            return
        }
    }
}
```

The function runs on the main actor because it presents a macOS window. The completion handler remains `nonisolated` because the system may invoke it outside of the `@MainActor` isolation context.

> Note: OAuthenticator normally contains a helper method for presenting the OAuth sign-in page. However, as of the time of this tutorial, the version used can crash on macOS after the authorization window closes. For now, this tutorial uses its own `authenticateUser(at:callbackURLScheme:)` function and completion handler as a workaround.
>
> Once this issue has been resolved, this portion of the walkthrough will not be needed.

### 7. Create the DPoP proof

OAuth tokens in this flow are bound to a DPoP key. When the app makes an authenticated request, it creates and signs a short-lived JWT that identifies the request and proves that the app has the matching private key.

In "OAuthController.swift," add a `struct` that contains the information included in the JWT:

```swift
public nonisolated struct DPoPClaims: JSONWebTokenPayload {

    public let jti: String

    public let iat: Date

    public let htm: String

    public let htu: String

    public let nonce: String?

    public let ath: String?

    public init(parameters: DPoPSigner.JWTParameters) {
        self.jti = UUID().uuidString
        self.iat = Date()
        self.htm = parameters.httpMethod
        self.htu = parameters.requestEndpoint
        self.nonce = parameters.nonce
        self.ath = parameters.tokenHash
    }
}
```

The claims describe the request being protected, but they are not yet a signed proof. Directly
below `DPoPClaims`, add a function that turns those claims and the account's DPoP key into the
signed JWT OAuthenticator expects:

```swift
public nonisolated func makeDPoPGenerator(
    dpopKey: DPoPKey
) -> DPoPSigner.JWTGenerator {
    return { parameters in
        let privateKey = try dpopKey.p256PrivateKey
        let publicJWK = JSONWebKey(p256Key: privateKey.publicKey)
        let token = JSONWebToken(
            header: JSONWebTokenHeader(
                algorithm: .ES256,
                type: parameters.keyType,
                keyId: dpopKey.id.uuidString,
                jwk: publicJWK
            ),
            payload: DPoPClaims(parameters: parameters)
        )

        return try token.encode(with: privateKey)
    }
}
```

`makeDPoPGenerator(dpopKey:)` uses Jot to sign the DPoP proofs requested by OAuthenticator.
`Bluesky.tokenHandling` requires the app to provide this generator. When restoring a saved `Login`
from this flow, also restore its original `DPoPKey`, because its access token and any refresh token
are bound to that cryptographic key. [TODO: Re-write this and check for accuracy, while still being short and easy to understand for beginner developers.]

### 8. Add the OAuth controller

While still inside of `OAuthController.swift`, create a new `struct` named `OAuthController`:

```swift
@MainActor
public final class OAuthController: ObservableObject {

    @Published public var handle = ""

    @Published public private(set) var isSigningIn = false

    @Published public private(set) var sessionResponse: String?

    public private(set) var client: ATProtoKit?

    public private(set) var bluesky: ATProtoBluesky?

    private let sessionStore = OAuthSessionStore(
        secureStore: AppleSecureKeychain(
            serviceName: "ca.cjrriley.ceupost.oauth"
        )
    )

    private var authenticator: Authenticator?

    private var sessionConfiguration: ATOAuthSessionConfiguration?

    private var verifiedIdentity: VerifiedIdentity?

    public init() {}
}
```

Now we'll get to implement the method used for signing into an account. Inside the `OAuthController` `class`, create a method, named `signIn()`, with the loading state:

```swift
public func signIn() async throws {
    self.isSigningIn = true

    defer {
        self.isSigningIn = false
    }
}
```

`defer` changes `isSigningIn` back to `false` whenever the method ends, including when an error occurs. The remaining lines will be added after the `defer` block.

- Note: Ignore the warning "`'defer' statement at end of scope always executes immediately; replace with 'do' statement to silence this warning`"; we will add code below that `defer` block once the next step is completed.

### 9. Resolve the entered handle

Before adding the first operation to `signIn()`, we'll need a `private` method to turn the entered handle into a freshly verified handle, DID, and PDS relationship. Add this method below `signIn()`:

```swift
private func resolveEnteredIdentity() async throws -> VerifiedIdentity {
    var identityResolver = IdentityResolver()

    return try await identityResolver.resolveVerifiedIdentity(
        handle: self.handle,
        forceRefresh: true
    )
}
```

Now return to `signIn()` and add this after the `defer` block:

```swift
let identity = try await self.resolveEnteredIdentity()
```

### 10. Discover the authorization server

`signIn()` will now need an authorization server, so we'll implement its helper first. ATProtoKit contains an extension to `URL`, named ``Foundation/URL/canonicalHTTPSOrigin()``, which lets the app validate and compare secure origins without
creating its own URL helpers.

Add the discovery method:

```swift
private func discoverAuthorizationServer(
    for identity: VerifiedIdentity
) async throws -> ServerMetadata {
    guard let pdsHost = identity.pds.host else {
        throw OAuthError.missingPDSHost
    }

    let provider = URLSession.defaultProvider
    let resource = try await ProtectedResourceMetadata.load(
        for: pdsHost,
        provider: provider
    )

    guard let resourceURL = URL(string: resource.resource) else {
        throw OAuthError.invalidAuthorizationServer
    }

    let resourceOrigin = try resourceURL.canonicalHTTPSOrigin()
    let pdsOrigin = try identity.pds.canonicalHTTPSOrigin()
    guard resourceOrigin == pdsOrigin else {
        throw OAuthError.resourceMismatch
    }

    guard let authorizationServers = resource.authorizationServers,
          authorizationServers.count == 1 else {
        throw OAuthError.invalidAuthorizationServers
    }

    let advertisedIssuer = authorizationServers[0]
    guard let issuerURL = URL(string: advertisedIssuer) else {
        throw OAuthError.invalidAuthorizationServer
    }

    _ = try issuerURL.canonicalHTTPSOrigin()

    guard let issuerHost = issuerURL.host else {
        throw OAuthError.invalidAuthorizationServer
    }

    let server = try await ServerMetadata.load(
        for: issuerHost,
        provider: provider
    )
    guard server.issuer == advertisedIssuer else {
        throw OAuthError.issuerMismatch
    }

    return server
}
```

Return to `signIn()` and add this immediately after `identity`:

```swift
let server = try await self.discoverAuthorizationServer(for: identity)
```

### 11. Restore a matching session

We only want to restore a session when it still belongs to the freshly verified DID, PDS, and issuer. We'll use the following helper to do just that:

```swift
private func matchingSavedSession(
    for identity: VerifiedIdentity,
    issuer: String
) async throws -> PersistedOAuthSession? {
    guard let savedSession = try await self.sessionStore.load(),
          savedSession.matches(identity: identity, issuer: issuer) else {
        return nil
    }

    return savedSession
}
```

After adding the above code in the `class`, add these lines to `signIn()`:

```swift
let savedSession = try await self.matchingSavedSession(
    for: identity,
    issuer: server.issuer
)
let dpopKey = savedSession?.dpopKey ?? DPoPKey.P256()
```

If the saved session matches, the original DPoP key is reused. Otherwise, a new key is created.

### 12. Implement OAuthenticator functionality

OAuthenticator needs closures for loading, saving, and clearing its `Login`. Add this method:

```swift
private func createLoginStorage(
    identity: VerifiedIdentity,
    issuer: String,
    dpopKey: DPoPKey
) -> LoginStorage {
    let expectedDID = identity.did
    let expectedHandle = identity.handle
    let expectedPDS = identity.pds

    return LoginStorage(
        retrieveLogin: { [sessionStore] in
            guard let savedSession = try await sessionStore.load(),
                  savedSession.did == expectedDID,
                  savedSession.pds == expectedPDS,
                  savedSession.issuer == issuer,
                  savedSession.dpopKey == dpopKey else {
                return nil
            }

            return savedSession.login
        },
        storeLogin: { [sessionStore] login in
            let savedSession = PersistedOAuthSession(
                login: login,
                dpopKey: dpopKey,
                handle: expectedHandle,
                did: expectedDID,
                pds: expectedPDS,
                issuer: issuer
            )
            try await sessionStore.save(savedSession)
        },
        clearLogin: { [sessionStore] in
            try await sessionStore.delete()
        }
    )
}
```

Next, add the callback URL used by the client metadata:

```swift
private func callbackURL() throws -> URL {
    guard let url = URL(string: "io.github.masterj93:/oauth/callback") else {
        throw URLError(.badURL)
    }

    return url
}
```

Now add the helper that creates the authenticator:

```swift
private func makeAuthenticator(
    identity: VerifiedIdentity,
    server: ServerMetadata,
    dpopKey: DPoPKey
) throws -> Authenticator {
    let expectedDID = identity.did
    let expectedIssuer = server.issuer
    let loginStorage = self.createLoginStorage(
        identity: identity,
        issuer: expectedIssuer,
        dpopKey: dpopKey
    )
    let tokenHandling = Bluesky.tokenHandling(
        account: identity.handle,
        server: server,
        jwtGenerator: makeDPoPGenerator(dpopKey: dpopKey),
        validator: { response, issuer in
            guard response.sub == expectedDID else {
                throw OAuthError.subjectMismatch
            }
            guard issuer == expectedIssuer else {
                throw OAuthError.issuerMismatch
            }
            guard response.scope.split(separator: " ").contains("atproto") else {
                throw OAuthError.missingATProtoScope
            }

            return true
        }
    )
    let credentials = AppCredentials(
        clientId: "https://masterj93.github.io/bluesky-oauth/ceupost/client-metadata.json",
        clientPassword: "",
        scopes: ["atproto"],
        callbackURL: try self.callbackURL()
    )
    let configuration = Authenticator.Configuration(
        appCredentials: credentials,
        loginStorage: loginStorage,
        tokenHandling: tokenHandling,
        mode: .manualOnly,
        userAuthenticator: { url, callbackURLScheme in
            return try await authenticateUser(
                at: url,
                callbackURLScheme: callbackURLScheme
            )
        }
    )

    return Authenticator(config: configuration)
}
```

Then return to `signIn()` and add:

```swift
let authenticator = try self.makeAuthenticator(
    identity: identity,
    server: server,
    dpopKey: dpopKey
)
let login = try await authenticator.authenticate()
```

At this point, OAuthenticator will restore or refresh a usable login. If it cannot, it presents the authorization page.

### 13. Create the ATProtoKit client

The final operation turns the authenticated login into an ATProtoKit client. At the end of the `class`, add a new method:

```swift
private func configureClient(
    identity: VerifiedIdentity,
    authenticator: Authenticator,
    login: Login
) async throws {
    let scopes: Set<String> = Set(
        login.scopes?
            .split(separator: " ")
            .map(String.init) ?? []
    )
    let context = SessionAuthorizationContext(
        sessionDID: identity.did,
        handle: identity.handle,
        serviceEndpoint: identity.pds,
        grantedScopes: scopes
    )
    let publicSession = URLSession(configuration: .default)
    let executor = ClosureATRequestExecutor { request, requirement in
        switch requirement {
        case .session:
            return try await authenticator.response(for: request)
        case .none:
            return try await publicSession.data(for: request)
        }
    }
    let sessionConfiguration = ATOAuthSessionConfiguration(
        context: context,
        requestExecutor: executor,
        deletionHandler: { [sessionStore] in
            try await sessionStore.delete()
        }
    )
    let client = try await ATProtoKit.createOAuthSession(
        sessionConfiguration: sessionConfiguration,
        canUseBlueskyRecords: true
    )

    self.authenticator = authenticator
    self.sessionConfiguration = sessionConfiguration
    self.verifiedIdentity = identity
    self.client = client
    self.bluesky = ATProtoBluesky(atProtoKitInstance: client)
}
```

Return to `signIn()` one last time and add this at the end of the block:

```swift
try await self.configureClient(
    identity: identity,
    authenticator: authenticator,
    login: login
)
```

`signIn()` is now complete. It remains short because each stage has its own method, and the tutorial introduced each method immediately before adding its call.

### 14. Verify the authenticated session

Before building the interface, let's add one small request that proves the session works. Add this method to `OAuthController`:

```swift
public func verifyAuthenticatedSession() async throws {
    self.sessionResponse = nil

    guard let client, verifiedIdentity != nil else {
        throw OAuthError.subjectMismatch
    }

    let session = try await client.getSession()
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

    let data = try encoder.encode(session)
    self.sessionResponse = String(decoding: data, as: UTF8.self)
}
```

``ATProtoKit/ATProtoKit/getSession()`` uses the PDS endpoint registered from the verified identity, so it works even when accounts are hosted by different providers. The lexicon method marks its request as requiring session authorization, causing the executor from `configureClient(identity:authenticator:login:)` to use OAuthenticator to authorize and send it. `JSONEncoder` only turns the typed response back into readable text for this sample interface.

### 15. Add sign-out

Add one more method to `OAuthController`:

```swift
public func signOut() async throws {
    if let sessionConfiguration {
        try await sessionConfiguration.removeSession()
    } else {
        try await sessionStore.delete()
    }

    self.authenticator = nil
    self.sessionConfiguration = nil
    self.verifiedIdentity = nil
    self.client = nil
    self.bluesky = nil
    self.sessionResponse = nil
}
```

``ATOAuthSessionConfiguration/removeSession()`` calls the deletion handler `configureClient(identity:authenticator:login:)`, then removes the session from ATProtoKit's registry. The remaining assignments remove the in-memory objects used by the interface.

At this point, all of the backend portions of OAuth are complete.

### 16. Connect the controller to SwiftUI

Now that we have the the OAuth implementation, we can finally add it to the app. However, before we do, we need to create the design of it.

Open "ContentView.swift." Then import `AuthenticationServices`:

```swift
import AuthenticationServices
import SwiftUI
```

After that, add a state object above `body`:

```swift
@StateObject private var oauth = OAuthController()

@State private var operationErrorMessage: String?
```

`@StateObject` keeps the same controller alive when SwiftUI updates the view. The separate `@State` property lets the view display an error thrown by sign-in, session verification, or sign-out.

Now replace the generated contents of `body` with a `Form` containing the handle field and sign-in button:

```swift
public var body: some View {
    Form {
        TextField("Handle", text: $oauth.handle)
            .textFieldStyle(.roundedBorder)

        Button("Sign in with AT Protocol") {
            Task {
                operationErrorMessage = nil

                do {
                    try await oauth.signIn()
                } catch {
                    let authenticationError = error as NSError

                    if authenticationError.domain == ASWebAuthenticationSessionErrorDomain,
                    authenticationError.code
                        == ASWebAuthenticationSessionError.Code.canceledLogin.rawValue {
                        operationErrorMessage = nil
                    } else {
                        operationErrorMessage = String(describing: error)
                    }
                }
            }
        }
        .disabled(oauth.handle.isEmpty || oauth.isSigningIn)

        if oauth.isSigningIn {
            ProgressView("Signing in…")
        }
    }
    .padding()
    .frame(minWidth: 460, minHeight: 240)
}
```

- Note: `AuthenticationServices` was imported because we simply needed to handle the error that arises whenever the browser window closed, either by the user or macOS. Otherwise, we could get the error message "The operation couldn't be completed. (com.apple.AuthenticationServices.WebAuthenticationSession error 1.)."

Next, add the signed-in controls inside the `Form`, after the progress view:

```swift
if oauth.client != nil {
    Text("Signed in. ATProtoKit is ready.")
        .foregroundStyle(.green)

    Button("Verify authenticated session") {
        Task {
            operationErrorMessage = nil

            do {
                try await oauth.verifyAuthenticatedSession()
            } catch {
                operationErrorMessage = String(describing: error)
            }
        }
    }

    Button("Sign Out", role: .destructive) {
        Task {
            operationErrorMessage = nil

            do {
                try await oauth.signOut()
            } catch {
                operationErrorMessage = String(describing: error)
            }
        }
    }
}
```

These controls appear only after ATProtoKit has been created successfully.

- Note: We're using `String(describing:)` because OAuthenticator's `AuthenticatorError` does not provide localized descriptions at the commit used by this tutorial. Using `error.localizedDescription` would hide useful cases and associated details behind a message such as `OAuthenticator.AuthenticatorError error 0`.

Finally, still inside the `Form`, display the response and any error thrown by an operation:

```swift
if let sessionResponse = oauth.sessionResponse {
    Text(sessionResponse)
        .font(.caption.monospaced())
        .textSelection(.enabled)
}

if let operationErrorMessage {
    Text(operationErrorMessage)
        .foregroundStyle(.red)
}
```

So long as `WindowGroup` displays `ContentView()`, "OAuthCheckApp.swift" will be left unchanged for this tutorial.

### 17. Build and run the app

We should have everything in place. Now it's time to test it out.

Select **My Mac**, then build and run the app. Enter an AT Protocol handle, select **Sign in with AT Protocol**, and once the browser window opens, complete the authorization page.

After the browser window closes, the app should display "Signed in. ATProtoKit is ready." Select **Verify authenticated session**. A successful response includes the account's details, including the handle and DID.

#### Test persistence

After signing in successfully:

1. Quit the app completely by pressing the Stop button on Xcode.
2. Build and run it again.
3. Enter the same handle.
4. Select **Sign in with AT Protocol**.

The app should still verify the identity and OAuth server. After those checks, OAuthenticator can reuse the access token or refresh it with the saved refresh token. The browser should stay closed while the saved authorization remains usable.

#### Test sign-out

If everything is working up until this point, we can finally test signing out.

Select **Sign Out**, then press Stop in Xcode and build and run after. Enter the same handle and sign in again. The authorization page should reappear because the saved login and DPoP key were deleted.

If the authorization page opens but the app does not return from it, compare these three values character for character:

- the redirect URI in `client-metadata.json`;
- the URL returned by `callbackURL()`; and
- the scheme registered under the target's **URL Types**.

Remember that the first two contain `:/oauth/callback`, while the registered scheme contains only the part before the colon.
