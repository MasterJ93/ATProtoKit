# ``ATProtoKit``

Develop and manage client and server-side applications for the AT Protocol and Bluesky.

@Metadata {
    @PageImage(
        purpose: icon, 
        source: "atprotokit_icon", 
        alt: "A technology icon representing the ATProtoKit framework.")
    @PageColor(blue)
}

## Overview

ATProtoKit is a Swift package designed for building applications and interacting with the AT Protocol (short for "Authenticated Transfer Protocol") and Bluesky. It provides all necessary client-side implementations to seamlessly interact with the AT Protocol, and fully integrates the various features of Bluesky. The library supports a wide range of functionalities, from identifier validations (including NSIDs, DIDs, Record Keys, AT-URIs, and more) to data stream viewing, offering a robust toolset for developers at all skill levels.

ATProtoKit aims to be easy enough to use for novice developers, while also being extendable and advanced enough for more experienced developers.

Below is a very quick example to run the project:
```swift
import ATProtoKit

let config = ATProtocolConfiguration(handle: "example.bsky.social", appPassword: "hunter2")

Task {
    print("Starting application...")

    do {
        try await config.authenticate()

        let atProto = await ATProtoKit(sessionConfiguration: config)
        let atProtoBluesky = ATProtoBluesky(atProtoKitInstance: atProto)

        let postResult = try await atProtoBluesky.createPostRecord(text: "Hello Bluesky!")

        print(postResult)
    } catch {
        print("Error: \(error)")
    }
}
```

ATProtoKit is fully open source under the [MIT license](https://github.com/MasterJ93/ATProtoKit/blob/main/LICENSE.md). You can take a look at it and make contributions to it [on GitHub](https://github.com/MasterJ93/ATProtoKit). Some of the documentation has been copied or adapted from [Bluesky's atproto repo](https://github.com/bluesky-social/atproto). ATProtoKit adopts the [MIT license](https://github.com/MasterJ93/ATProtoKit/blob/main/ATProtoLicense/ATPROTO-LICENSE.txt) from their repo.

## What's New in ATProtoKit
@Links(visualStyle: detailedGrid) {
    - <doc:0210AuthFlowChange>
    - <doc:getRecordTutorial>
    - <doc:ATProtoIdentifiers>
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
- ``ATRecordViewProtocol``
- ``ATRecordTypeRegistry``
- ``ATRecordConfiguration``
- ``ATUnion``

@Comment {
    The following should be added:
    Records Overview (Article)
    Creating Your Own Records (Article)
    Converting a Lexicon Into a Model-Method Pair (Article)
}

### UnknownType
- ``UnknownType``
- ``CodableValue``
- <doc:getRecordTutorial>

### Interacting With Users

@Comment {
    
}

### Identifiers and Schemes

- <doc:ATProtoIdentifiers>
- ``ATURIManager``
- ``DIDManager``
- ``HandleManager``
- ``NSIDManager``
- ``RecordKeyManager``

### Event Streams

- ``ATEventStreamConfiguration``
- ``ATFirehoseStream``
- ``FirehoseEventRepresentable``
- ``CBORDecodedBlock``
- ``ATCBORManager``

@Comment {
    The following should be added:
        Overview of Data Streams (Article)
        Extending ATDataStreamConfiguration For Accessing Your Service’s Data Stream (Article)
        LepidWatch: Accessing Bluesky’s Firehose Data Stream (Sample Code)
}

### Utilities
- ``ATProtoTools``
- <doc:DateFormatting-PropertyWrapper>
- ``ATFacetParser``

@Comment {
    The following should be added:
        Creating a Custom Image Processor (Article)
}

### Error Handling

- ``ATProtoError``
