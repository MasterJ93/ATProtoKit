# ``ATProtoKit``

Develop and manage client and server-side applications for the AT Protocol and Bluesky.

@Metadata {
    @PageImage(
        purpose: icon, 
        source: "atprotokit_logo", 
        alt: "A technology icon representing the ATProtoKit framework.")
}

## Overview

ATProtoKit is a Swift package designed for building applications and interacting with the AT Protocol and Bluesky. It provides all necessary client-side implementations to seamlessly interact with the AT Protocol, and fully integrates the diverse features of Bluesky. The library supports a wide range of functionalities, from data type validations (including NSID, DID, Record Key, AT-URI, TID, CID, and more) to data stream viewing, offering a robust toolset for developers at all skill levels.

ATProtoKit aims to be easy enough to use for novice developers, while also being extendable and advanced enough for more experienced developers.

Below is a very quick example to run the project:
```swift
import ATProtoKit

let config = ATProtocolConfiguration(handle: "example.bsky.social", appPassword: "app-password")

Task {
    let session = try await config.authenticate()

    switch session {
    case .success(let result):
        let atProto = ATProtoKit(session: result)
        let postResult = await atProto.createPostRecord(text: "Hello Bluesky!")
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

## Topics

### Essentials

- ``ATProtoAdmin``
- ``ATProtoKit/ATProtoKit``

### Authentication and Session Management


### Lexicons and Records


### Interacting With Users


### Data Streams


### Utilities
- ``APIClientService``
- ``ATImageProcessable``
- ``DateFormatting``
- ``DateFormattingOptional``

### Error Handling


### Tutorials
