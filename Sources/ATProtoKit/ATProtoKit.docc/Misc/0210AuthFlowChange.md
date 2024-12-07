# 0.20 to 0.21 Authentication Flow Migration

Learn about how to set up your project with the new authentication flow changes.

With the release of 0.21.0 comes a new migration flow for ATProtoKit developers. This change is fairly small, but this article will still cover what to expect in order to clear any confusion.

## Authentication Flow

Previously, when you wanted to authenticate to an AT Protocol service, you used an initializer from ``ATProtocolConfiguration``, then used ``ATProtocolConfiguration/authenticate(authenticationFactorToken:)`` and passed the ``UserSession`` object into the main ``ATProtoKit/ATProtoKit`` `class`:

```swift
let config = ATProtocolConfiguration(
    handle: example.bsky.social,
    password: hunter2
)

Task {
    do {
        let session = try await config.authenticate()
        let atProto = ATProtoKit(session: session)
    } catch {
        throw error
    }
}
```

While this worked well, if you wanted to use the `refreshSession()` or `deleteSession()` methods (which would directly replace or delete the `UserSession` object respectively), it would be very difficult to do so.

With version 0.21.0, you can now authenticate like this:

```swift
let config = ATProtocolConfiguration(handle: example.bsky.social, password: hunter2)

Task {
    do {
        // You can put it in here…
        try await config.authenticate()

        let atProto = ATProtoKit(sessionConfiguration: config)

        // Or here…
        try await config.authenticate()
    } catch {
        throw error
    }
}
```

Here are the changes being made:
- ``ATProtocolConfiguration`` now stores the ``UserSession`` object: ``ATProtocolConfiguration/session``.
- The main ``ATProtoKit/ATProtoKit`` `class` now asks for a ``SessionConfiguration`` object instead of a ``UserSession`` object. ``ATProtocolConfiguration`` is a ``SessionConfiguration``-conforming `class`.
- ``ATProtocolConfiguration/authenticate(authenticationFactorToken:)`` no longer returns anything.
  - Due to the above change, you can now have the option to authenticate before or after creating the main `ATProtoKit` `class`.
- ``ATProtocolConfiguration`` now accesses the following via proxy methods:

`ATProtoKit` method|Proxy Method
---:|:---
``ATProtoKit/ATProtoKit/createSession(with:and:authenticationFactorToken:pdsURL:)``|``ATProtocolConfiguration/authenticate(authenticationFactorToken:)``
``ATProtoKit/ATProtoKit/getSession(by:pdsURL:)``|``ATProtocolConfiguration/getSession(by:pdsURL:)``
``ATProtoKit/ATProtoKit/refreshSession(refreshToken:pdsURL:)``| ``ATProtocolConfiguration/refreshSession()``
``ATProtoKit/ATProtoKit/deleteSession(refreshToken:pdsURL:)``|``ATProtocolConfiguration/deleteSession()``
``ATProtoKit/ATProtoKit/createAccount(email:handle:existingDID:inviteCode:verificationCode:verificationPhone:password:recoveryKey:plcOperation:pdsURL:)``| ``ATProtocolConfiguration/createAccount(email:handle:existingDID:inviteCode:verificationCode:verificationPhone:password:recoveryKey:plcOperation:)``



---

There isn’t that much you need to do:

```swift
// Remove the assignment as it’s no longer needed.
// Before:
let session = try await config.authenticate()

// After:
try await config.authenticate()

// Change the argument name from `session` to `sessionConfiguration`.
// Before:
let atProto = ATProtoKit(session: session)

// After:
let atProto = ATProtoKit(sessionConfiguration: config)
```

## Creating Your Own SessionConfiguration Class

While this was already possible, new in 0.21.0, you can now create your own ``SessionConfiguration`` (formally called `ProtocolConfiguration`) `class`. This is for situations where you feel like ``ATProtocolConfiguration`` isn’t well-made for your needs. To learn more about creating a `SessionConfiguration` `class`, go to the ``SessionConfiguration`` documentation.
