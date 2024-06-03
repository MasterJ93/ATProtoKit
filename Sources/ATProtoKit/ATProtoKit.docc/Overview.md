# ``ATProtoKit``

Develop and manage client and server-side applications for the AT Protocol and Bluesky.

@Metadata {
    @PageImage(
        purpose: icon, 
        source: "atprotokit_logo", 
        alt: "A technology icon representing the ATProtoKit framework.")
    @PageColor(blue)
}

## Overview

ATProtoKit is a Swift package designed for building applications and interacting with the AT Protocol (short for "Authenticated Transfer Protocol") and Bluesky. It provides all necessary client-side implementations to seamlessly interact with the AT Protocol, and fully integrates the various features of Bluesky. The library supports a wide range of functionalities, from data type validations (including NSID, DID, Record Key, AT-URI, TID, CID, and more) to data stream viewing, offering a robust toolset for developers at all skill levels.

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

## What's New in ATProtoKit
@Links(visualStyle: detailedGrid) {
    - <doc:Getting-Started-with-ATProtoKit>
}

## Topics

### Essentials

- <doc:Getting-Started-with-ATProtoKit>

@Comment {
    Add a tutorial named "Meet ATProtoKit".
}

- ``ATProtoKit/ATProtoKit``
- ``ATProtoAdmin``
- ``ATProtoBluesky``
- ``ATProtoBlueskyChat``

### Authentication and Session Management

- ``ATProtoKit/ATProtoKitConfiguration``
- ``ATProtocolConfiguration``
- ``UserSession``
 
 @Comment {
     The following should be added:
        Creating and Managing a Session (Article)
 }
 
### Lexicons and Records

- ``AppBskyLexicon``
- ``ChatBskyLexicon``
- ``ComAtprotoLexicon``
- ``ToolsOzoneLexicon``
- ``ATRecordProtocol``
- ``ATRecordTypeRegistry``
- ``ATUnion``

@Comment {
    The following should be added:
    Records Overview (Article)
    Creating Your Own Records (Article)
    Converting a Lexicon Into a Model-Method Pair (Article)
}

### UnknownType
- ``UnknownType``

### Interacting With Users

@Comment {
    
}

### Data Streams

- ``ATCBORManager``

@Comment {
    The following should be added:
        Overview of Data Streams (Article)
        Extending ATDataStreamConfiguration For Accessing Your Service’s Data Stream (Article)
        LepidWatch: Accessing Bluesky’s Firehose Data Stream (Sample Code)
}

### Utilities
- ``ATProtoTools``
- ``APIClientService``
- ``ATImageProcessable``
- <doc:DateFormatting-PropertyWrapper>
- ``ATFacetParser``

@Comment {
    The following should be added:
        Creating a Custom Image Processor (Article)
}

### Error Handling

- ``ATProtoError``
