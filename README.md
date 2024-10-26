<p align="center">
  <img src="https://github.com/MasterJ93/ATProtoKit/blob/ed45edcd717e7341ae688d294504e0019550b3f0/atprotokit_logo.png" height="128" alt="A logo for ATProtoKit, which contains three stacks of rounded rectangles in an isometric top view. At the top stack, the at symbol is in a thick weight, with clouds as the symbol’s colour. The three stacks are darker shades of blue.">
</p>

<h1 align="center">ATProtoKit</h1>

<p align="center">A straightforward solution for using the AT Protocol and Bluesky, written in Swift.</p>

<div align="center">

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FMasterJ93%2FATProtoKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/MasterJ93/ATProtoKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FMasterJ93%2FATProtoKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/MasterJ93/ATProtoKit)
[![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/masterj93/atprotokit?logo=github)](https://github.com/MasterJ93/ATProtoKit)
[![GitHub Repo stars](https://img.shields.io/github/stars/masterj93/atprotokit?style=flat&logo=github)](https://github.com/MasterJ93/ATProtoKit)


</div>
<div align="center">

[![Static Badge](https://img.shields.io/badge/Follow-%40cjrriley.com-0073fa?style=flat&logo=bluesky&labelColor=%23151e27&link=https%3A%2F%2Fbsky.app%2Fprofile%2Fcjrriley.com)](https://bsky.app/profile/cjrriley.com)

</div>

---
> [!CAUTION]
> ***This API library is highly unstable. Things will change. Things are incomplete. Things will break. Until the project reaches version 1.0.0, stability will not be guaranteed.***

ATProtoKit is an easy-to-understand API library that leverages the AT Protocol with the type-safety and ease-of-use you’ve come to expect with the Swift programming language. Whether you’re building a bot, a server app, or just another user-facing Bluesky client, this project should hopefully get you up to speed.


## Example Usage
```swift
let config = ATProtocolConfiguration(handle: "lucy.bsky.social", appPassword: "hunter2")

Task {
    print("Starting application...")

    do {
        let session = try await config.authenticate()

        let atProto = ATProtoKit(session: session)
        let atProtoBluesky = ATProtoBluesky(atProtoKitInstance: atProto)

        let postResult = try await atProtoBluesky.createPostRecord(text: "Hello Bluesky!")

        print(postResult)
    } catch {
        print("Error: \(error)")
    }
}
```

## Motivation
I believe Bluesky and its accompanying AT Protocol gives the perfect balance between embracing decentralization and simplifying the user experience. Because of this, I wanted a way for Swift developers to use the AT Protocol in a way that feels right at home, both client-side with Apple's platforms, and server-side with Linux. For this reason, I decided to open source this project.


## Features
- [x] Full compatibility with Apple’s APIs for each of the platforms.
- [x] Written with adherence to the Swift API Design Guidelines.
- [ ] Well-written documentation for all of the AT Protocol and Bluesky APIs.
- [x] A RichText helper to parse text into the applicable facets.
- [ ] Easily identify and validate different identifiers.
- [ ] A powerful Firehose API that retrieves and filters events and records in real-time.
- [ ] An HTML-parsing system to grab search engine-friendly elements for embeds.
- [x] A logging tool for easy debugging.

> [!NOTE]
> Not all features above have been implemented; however, they will be, soon.


## Installation
You can use the Swift Package Manager to download and import the library into your project:
```swift
dependencies: [
    .package(url: "https://github.com/MasterJ93/ATProtoKit.git", from: "0.19.0")
]
```

Then under `targets`:
```swift
targets: [
    .target(
        // name: ...,
        dependencies: [
            .product(name: "ATProtoKit", package: "atprotokit")
        ]
    )
]
```

## Roadmap
The Projects page isn't completed, but you can still view it through its [Projects](https://github.com/users/MasterJ93/projects/2) page.

## Quick Start
As shown in the Example Usage, it all starts with `ATProtocolConfiguration`, which uses the handle, app password, and pdsURL to access and create a session:
```swift
import ATProtoKit

let config = ATProtocolConfiguration(handle: "lucy.bsky.social", appPassword: "hunter2")
```

By default, `ATProtocolConfiguration` conforms to `https://bsky.social`. However, if you’re using a different distributed service, you can specify the URL:
```swift
let result = ATProtocolConfiguration(handle: "lucy.example.social", appPassword: "hunter2", pdsURL: "https://example.social")
```

This session contains all of the elements you need, such as the access and refresh tokens:
```swift
Task {
    do {
        let session = try await config.authenticate()

        print("Result (Access Token): \(session.accessToken)")
        print("Result (Refresh Token): \(session.refreshToken)")
    } catch {
        print("Error: \(error)")
    }
}
```

## Requirements
To use ATProtoKit in your apps, your app should target the specific version numbers:
- **iOS** and **iPadOS** 14 or later.
- **macOS** 13 or later.
- **tvOS** 14 or later.
- **visionOS** 1 or later.
- **watchOS** 9 or later.

For Linux, you need to use Swift 6.0 or later. At this time, you must use `@preconcurrency` when importing ATProtoKit. On Linux, the minimum requirements include:
- **Ubuntu** 18.04
- **CentOS** 7
- **Red Hat UBI** 9
- **Debian** 12
- **Fedora** 39

You can also use this project for any programs you make using Swift and running on **Docker**.

> [!WARNING]
> As of right now, Windows support is theoretically possible, but not has not been tested to work. For other platforms (such as Android), this is also not tested, but should be theoretically possible. While it’s not a goal to make it fully compatible, contributions and feedback on the matter are welcomed.


## Submitting Contributions and Feedback
While this project will change significantly, feedback, issues, and contributions are highly welcomed and encouraged. If you'd like to contribute to this project, please be sure to read both the [API Guidelines](https://github.com/MasterJ93/ATProtoKit/blob/main/API_GUIDELINES.md) as well as the [Contributor Guidelines](https://github.com/MasterJ93/ATProtoKit/blob/main/CONTRIBUTING.md) before submitting a pull request. Any issues (such as bug reports or feedback) can be submitted in the [Issues](https://github.com/MasterJ93/ATProtoKit/issues) tab. Finally, if there are any security vulnerabilities, please read [SECURITY.md](https://github.com/MasterJ93/ATProtoKit/blob/main/SECURITY.md) for how to report it.

If you have any questions, you can ask me on Bluesky ([@cjrriley.com](https://bsky.app/profile/cjrriley.com)). And while you're at it, give me a follow! I'm also active on the [Bluesky API Touchers](https://discord.gg/3srmDsHSZJ) Discord server.

## License
This Swift package is using the MIT License. Please view [LICENSE.md](https://github.com/MasterJ93/ATProtoKit/blob/main/LICENSE.md) for more details.

The documentation text used by Bluesky is licenced under the MIT Licence. Please view [ATPROTO-LICENSE.md](ATProtoLicense/ATPROTO-LICENSE.txt) for more details.
