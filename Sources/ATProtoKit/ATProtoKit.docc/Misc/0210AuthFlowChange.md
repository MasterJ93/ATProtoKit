# 0.21 to 0.26 Authentication Flow Migration

Learn about how to set up your project with the new authentication flow changes.

With the release of 0.26.0 comes a new migration flow for ATProtoKit developers. This change is fairly small, but this article will still cover what to expect in order to clear any confusion.

## Authentication Flow

Previously, when you wanted to authenticate to an AT Protocol service, you used an initializer from ``ATProtocolConfiguration``, which contained the `handle` and `password` parameters. Then, you would use ATProtocolConfiguration.authenticate(authenticationFactorToken:) and passed the instance to the ``ATProtoKit`` `class`:

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

With version 0.26, this has been changed slightly:
```swift
let config = ATProtocolConfiguration()

Task {
    do {

        let atProto = ATProtoKit(sessionConfiguration: config)

        // Enter the handle and password in here.
        try await config.authenticate(
            handle: example.bsky.social,
            password: hunter2
        )
    } catch {
        throw error
    }
}
```

Here are the changes being made:
- ``ATProtocolConfiguration``'s initializer no longer takes the `handle` or `password` parameters: now, ``ATProtocolConfiguration/authenticate(with:password:)`` is responsible.

This is the only external change. However, more has been made internally:
- ``UserSession`` is no longer stored inside of ``ATProtocolConfiguration``: now, a new `actor` named ``UserSessionRegistry`` holds all instances of the `struct`.
- A `UUID` value has been added to the ``ATProtocolConfiguration`` `class`. This value is linked to all objects that are related to the session. This is part of the new initializer for ``ATProtocolConfiguration``, named ``ATProtocolConfiguration/init(pdsURL:keychainProtocol:configuration:canResolve:)``.
- ``ATProtocolConfiguration`` now closely follows ``SessionConfiguration``. In fact, the following methods are no longer stored in the `class`, but have moved to default implementations of the `protocol`:
  - ``ATProtocolConfiguration/authenticate(with:password:)``
  - ``ATProtocolConfiguration/getSession()``
  - ``ATProtocolConfiguration/refreshSession()``
  - ``ATProtocolConfiguration/deleteSession()``
- A new `protocol`, named ``SecureKeychainProtocol``, will now manage the management of the password, access token, and refresh token. An `actor`, named ``AppleSecureKeychain`` is available for applications running on Apple's platforms.

## `SessionConfiguration`

As mentioned previously, ``SessionConfiguration`` now has default configurations for each of the required methods. It is also `Sendable` and requires a `class` to conform to it. The default implementation assumes you're using an App Password to authenticate by default, but you're able to create new implementations for your own conforming `class`.

Furthermore, the ``SessionConfiguration/authenticate(with:password:)`` method handles Two-Factor Authentication, but the `protocol` can also handle OAuth. This is thanks to a `AsyncStream`-related properties, named ``SessionConfiguration/codeContinuation`` and ``SessionConfiguration/codeStream``.

## Auto-managing the Keychain

As mentioned earlier, a new `protocol` and `actor` have been made: ``SecureKeychainProtocol`` and ``AppleSecureKeychain`` respectively. This manages the keychain items for the password and refresh token, as well as storing the access token in-memory.
- Note: The access token is being stored in-memory due to how frequently the token expires.

``AppleSecureKeychain`` conforms to ``SecureKeychainProtocol`` and is the default object used for Apple platforms. It's also the default object used when initializing with ``ATProtocolConfiguration``. However, you're free to create your own implementation if it doesn't suit your needs.
- Note: At this time, Linux and Windows developers will need to implement their own `actor` or `class` to achieve the same effect. However, default `actor`s for those platforms will be created at a later date.

