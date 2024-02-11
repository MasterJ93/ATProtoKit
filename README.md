#  ATProtoKit
A straightforward solution for using the AT Protocol and Bluesky, written in Swift.

***This API library is highly unstable. Things will change. Things will break. Until the project reaches version 1.0.0, stability will not be guaranteed.***
---

ATProtoKit is an easy-to-understand API library that leverages the AT Protocol with the type-safety and ease-of-use you’ve come to expect with the Swift programming language. Whether you’re building a bot, a server app, or just another Bluesky client, this project should hopefully get you up to speed.

## Example Usage
```swift
let config = ATProtocolConfiguration(handle: "example.bsky.social", appPassword: "app-password")

Task {
    let result = try await config.authenticate()
    switch result {
        case .success(let result):
            let atProto = ATProtoKit(session: result)
            let postResult = await atProto.createPostRecord(text: "Hello Bluesky!")
        case .failure(let error):
            print("Error: \(error)")
}
```

## Motivation
I believe Bluesky and its accompanying protocol gives the perfect balance between embracing decentralization and simplifying the user experience. Because of this, I wanted a way for Swift developers to use the AT Protocol in a way that feels right at home, both client-side with Apple's platform's, and server-side with Linux. For this reason, I decided to open source this project.

## Features
- Full compatibility with Apple’s APIs for each of the platforms.
- Written with adherence to the Swift API Design Guidelines and up-to-date best practices.
- Uses Swift’s powerful type inference and pattern matching for cleaner, more readable code.
- Created in a way that’s type-safe, reliable, and min.
- Well-written documentation for all of the AT Protocol and Bluesky APIs.
- A RichText helper to parse text into the applicable facet.
-  Extend the capabilities of generic structures within the AT Protocol in case your instance requires it.
- A powerful Firehose API that retrieves and filters events and records in real-time.
- An HTML-parsing system to grab search engine-friendly elements for embeds.
- A logging tool for easy debugging.

## Installation
You can use the Swift Package Manager to download and import the library into your project:
```swift
dependencies: [
    .package(url: "https://github.com/mountainpaw/ATProtoKit.git", from: "0.1.0")
]
```

## Roadmap
The Projects page isn't set up yet, so it'll be a while before you can see the progress for this project. However, some of the goals include:
- Making the library fully compatible for Linux, for both client-side and server-side applications.
- Replacing SwiftSoup to a more laser-focused Swift Package dedicated for the AT Protocol and Bluesky.
- Adding a separate package for auto-generating lexicons best on the Swift API Design Guidelines, Swift best practices, and this project’s own API design guidelines.

## Quick Start
As shown in the Example Usage, it all starts with `ATProtocolConfiguration`, which uses the handle, app password, and pdsURL to access and create a session:
```swift
import ATProtoKit

let config = ATProtocolConfiguration(handle: "example.bsky.social", appPassword: "app-password")
```

By default, `ATProtocolConfiguration` conforms to `https://bsky.social`. However, if you’re using a different distributed service, you can specify the URL:
```swift
let result2 = ATProtocolConfiguration(handle: "example.example.social", appPassword: "app-password", pdsURL: "https://example.social")
```

This session contains all of the elements you need, such as the access and refresh tokens:
```swift
Task {
    print("Starting application...")
    let result = try await config.authenticate()

    switch result {
        case .success(let result):
            print("This works!")
            print("Result (Access Token): \(result.accessToken)")
            print("Result (Refresh Token): \(result.refreshToken)")
        case .failure(let error):
            print("Error: \(error)")
    }
}
```

## Requirements
To use ATProtoKit in your apps, your app should target the specific version numbers:
- iOS and iPadOS 13 or later.
- macOS 12 or later.
- tvOS 13 or later.
- watchOS 6 or later.
(Given now new it is, there are no version requirements for visionOS.)

As of right now, Linux support is theoretically possible, but not guaranteed to be tested. The plan is to make it fully compatible with Linux by version 1.0, though this is not a required goal to get there. For other platforms (such as Android), this is also not tested, but should be theoretically possible. While it’s not a goal to make it fully compatible, contributions and feedback on the matter are welcomed.

## Contributions and Feedback
While this project will change signifcantly, early feedback, issues, and contributions is highly welcomed and encouragd. At a later date, I'll post some contributor guidelines and templates, but since this project is in its early days, I have yet to have a significant amount of time in terms of thinking of this. However, some of the things to keep in mind are:
- Be sure to adhere to the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) when contributing code.
- 

## Licence
This Swift Package is using the MIT Licence. Please view LICENCE.md for more details.
