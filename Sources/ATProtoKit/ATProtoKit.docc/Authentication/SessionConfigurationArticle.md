# Implementing `SessionConfiguration`

Discover how to utilize `SessionConfiguration` to better fit your use case.

## Overview

``SessionConfiguration`` is a simple but powerful tool for managing sessions. While ``ATProtocolConfiguration`` is useful for most uses, there may be situations where it might fall short.

In this article, you'll learn how to implement custom instances for some specific use cases.

## The Role and Structure of SessionConfiguration

This `protocol` requires a few methods and properties. They relate to:
- Creating and managing sessions.
- Creating instances of ``UserSession``.
- Managing the keychain.
- Providing pauses in order to handle additional user input.

- Note: `SessionConfiguration` requires that your `class` is marked as `final` and it conforms to `Sendable`.

To help with this, there's two objects that work alongside it:
- ``UserSessionRegistry``, which stores all instances of ``UserSession``.
- ``SecureKeychainProtocol``, which stores the session tokens and password.

Specifically with `SecureKeychainProtocol`, Apple platforms has a default `actor` that conforms to the `protocol`: ``AppleSecureKeychain``.
- Note: Linux and Windows users lack a default implementation for now. This may change in future updates.

`SessionConfiguration` also contains default implementations on all of the methods. Namely:
- ``SessionConfiguration/createAccount(email:handle:existingDID:inviteCode:verificationCode:verificationPhone:password:recoveryKey:plcOperation:)``
- ``SessionConfiguration/authenticate(with:password:)``
- ``SessionConfiguration/getSession()``
- ``SessionConfiguration/refreshSession()``
- ``SessionConfiguration/deleteSession()``

With these implementations, you don't have to start from scratch: if there's a method that already works for your needs, but some others requires a custom implementation, then you're free to ignore it.

Finally, there are properties that provide pausing opportunities so that the user can perform actions outside of the app, such as getting a Two-Factor Authentication code, or waiting for the server to state that the user has completed the OAuth requirements. These are `AsyncStream` properties, named ``SessionConfiguration/codeStream`` and ``SessionConfiguration/codeContinuation``.

## Use Cases

There are some use cases that ATProtoKit doesn't include right out of the box at this time. This section will cover those use cases, as well as how to implement them.

### Resolving PDS Links

ATProtoKit typically retrieves the service endpoint from the Personal Data Server (PDS) once the authentication process is complete. However, you'll ideally want to retrieve that link before you authenticate. If you wish to do this, you can add this to the authentication process.

- Note: In this example, we'll be using [ATResolve](https://github.com/mattmassicotte/ATResolve), which is perfect for what we need.

Once you add the package as a dependency and you create a new `class`, Override the ``SessionConfiguration/authenticate(with:password:)`` method to implement the following:
```swift
public func MySessionConfigurationClass: SessionConfiguration {

    // Properties and initializer implemented above...

    public func authenticate(with handle: String, password: String) async throws {
        let serviceEndpoint: URL

        do {
            // Resolve the handle to make sure it exists.
            let resolver = ATResolver()
            let resolvedHandle = try await resolver.resolveHandle(handle)

            guard let serviceEndpointString = resolvedHandle?.serviceEndpoint,
                  let serviceEndpointURL = URL(string: serviceEndpointString) else {
                    throw DIDDocument.DIDDocumentError.noATProtoPDSValue
            }

            serviceEndpoint = serviceEndpointURL
        } catch {
            throw error
        }
    }
}
```

In the above example, we create an instance of `ATResolve`. After that, we use `resolveHandle()` and pass in the `handle` property as the argument. `ATResolve` will find the DID document associated with the handle, which will contain the service endpoint. Once you're done, all that's left to do is extract the URL.

You can now use this to pass the `serviceEndpoint` variable into the `pdsURL` parameter of ``ATProtoKit/ATProtoKit/init(sessionConfiguration:pdsURL:canUseBlueskyRecords:)``, and then call the ``ATProtoKit/ATProtoKit/createSession(with:and:authenticationFactorToken:)`` method.
