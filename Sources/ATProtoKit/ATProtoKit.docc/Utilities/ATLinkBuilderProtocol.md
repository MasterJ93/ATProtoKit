# Creating Link Previews with ATLinkBuilder

Grab metadata from URLs so you can attach them to a website card in a Bluesky post.

## Overview

``ATLinkBuilder`` allows you to compile the link with the appropriate metadata to create an external link card in a Bluesky post. This is a `protocol`, so you can use how you want to perform this task.

### Getting Started

`ATLinkBuilder` can be attached to a `struct` or `class`. The only required method, ``ATLinkBuilder/grabMetadata(from:)``, returns a tuple, which contains the URL, website title, description, and thumbnail image URL.

```swift
public protocol ATLinkBuilder {
    func grabMetadata(from link: URL) async throws -> (
        url: URL,
        title: String,
        description: String?,
        thumbnailURL: URL?
    )
}
```

- Note: While `description` is optional, you still need a description for the embed.

## Grabbing the Website’s Metadata

To get the metadata of the website, you’ll need to implement ``ATLinkBuilder/grabMetadata(from:)``. There’s an argument where you pass the URL so it can do its work.

The way you implement it is up to you. You can:
- use an external API from a server that does the work for you,
- use a Swift package that can parse website metadata, or
- write the implementation yourself from scratch.

For this example, we’ll use a mock server that does the compilation for us and gives us the information as a JSON object.

```swift

public struct ExternalLinkBuilder: ATLinkBuilder {
    public func grabMetadata(from link: URL) async throws -> (url: URL, title: String, description: String?, thumbnailURL: URL?) {
        guard let serverURL = URL(string: "https://linkBuilder.example.com/api/metadata?link=\(link.absoluteString)") else {
            throw ATLinkBuilderError.invalidURL("The URL, \(link), is invalid.")
        }

        let (data, response) = try await URLSession.shared.data(from: serverURL)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ATLinkBuilderError.badServerResponse(string: "Bad server response: \(response)")
        }

        struct MetadataResponse: Decodable {
            let title: String
            let description: String?
            let thumbnailURL: URL?
        }

        let decoder = JSONDecoder()
        let metadata = try decoder.decode(MetadataResponse.self, from: data)

        return (url: link, title: metadata.title, description: metadata.description ?? "No description given.", thumbnailURL: metadata.thumbnailURL)
    }
}

```

- Note: It’s important to throw errors if the URL is invalid or not found. Any additional errors can be unknown. See ``ATLinkBuilderError`` for the list of errors to throw.

## Integration into ATProtoBluesky

Once you’ve completed creating the `ATLinkBuilder`-conforming object, you can put this as an argument in ``ATProtoBluesky``. The `class` contains an argument named `linkBuilder`:

```swift
let config = ATProtocolConfiguration(
    handle: "example.bsky.social",
    appPassword: "hunter2"
)

Task {
    do {
        // Create an instance of the conforming object...
        let externalEmbedBuilder = ExternalLinkBuilder()

        let session = try await config.authenticate()

        guard let link = URL(string: "https://bsky.social/about/blog/04-01-2024-bluesky-shorts") else { return }
        let metadata = try await externalEmbedBuilder.grabMetadata(from: link)

        let atProto = ATProtoKit(session: session)

        let atProtoBluesky = ATProtoBluesky(
            atProtoKitInstance: atProto,
            linkbuilder: externalEmbedBuilder // ... and add the object in here.
        )

    } catch {
        // Handle error...
    }
}
```

You can then create a post as normal using ``ATProtoBluesky/createPostRecord(text:inlineFacets:locales:replyTo:embed:labels:tags:creationDate:recordKey:shouldValidate:swapCommit:)``.

The mthod will automatically take the first link it detects and use it as the external website card.

## Manually Creating a Website Card

Optionally, you can also use the `embed` argument of `createPostRecord()`. When doing so, you can use the `ATLinkBuilder`-conforming object to grab the metadata and paste the result. This is useful for when you want to create a post that doesn't doesn't have the link copied over to the website card.


```swift
Task {
    do {
        let session = try await config.authenticate()

        let externalLinkBuilder = ExternalLinkBuilder()

        guard let link = URL(string: "https://www.nintendo.com/") else { return }
        let metadata = try await externalLinkBuilder.grabMetadata(from: link)

        let atProto = ATProtoKit(session: session)
        let atProtoBluesky = ATProtoBluesky(atProtoKitInstance: atProto)

        let postResult = try await atProtoBluesky.createPostRecord(
            text: "Testing the link builder:\n\nhttps://www.apple.com/",
            embed: .external(
                url: metadata.url,
                title: metadata.title,
                description: metadata.description ?? "No description given.",
                thumbnailURL: metadata.thumbnailURL
            )
        )

        print("Post Result: \(postResult)")
    } catch {
        throw error
    }
}
```

## Topics

- ``ATLinkBuilder``
