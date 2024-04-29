//
//  BskyEmbedExternal.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-26.
//

import Foundation

// MARK: - Main definition
/// The main data model definition for external embeds.
///
/// - Note: According to the AT Protocol specifications: "A representation of some externally linked content (eg, a URL and 'card'), embedded in a Bluesky record (eg, a post)."
///
/// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/external.json
public struct EmbedExternal: Codable {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public let type: String = "app.bsky.embed.external"
    /// The external content needed to be embeeded.
    public let external: External

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case external
    }
}
// MARK: -
/// A data model for an external definition.
///
/// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/external.json
public struct External: Codable {
    /// The URI of the external content.
    public let embedURI: String
    /// The title of the external content.
    public let title: String
    /// The description of the external content.
    public let description: String
    /// The thumbnail image of the external content.
    ///
    /// - Warning: The image size can't be higher than 1 MB. Failure to do so will result in the image failing to upload.
    public let thumbnailImage: UploadBlobOutput?

    enum CodingKeys: String, CodingKey {
        case embedURI = "uri"
        case title
        case description
        case thumbnailImage = "thumb"
    }
}

/// A data model for an external view definition.
///
/// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/external.json
public struct EmbedExternalView: Codable {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public let type: String = "app.bsky.embed.external#view"

    /// The external content embedded in a post.
    public let external: ViewExternal

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case external
    }
}

/// A data model for a definition for the external content.
public struct ViewExternal: Codable {
    /// The URI of the external content.
    public let embedURI: String
    /// The title of the external content.
    public let title: String
    /// The description of the external content.
    public let description: String
    /// The thumbnail image URL of the external content.
    public let thumbnailImageURL: URL?

    enum CodingKeys: String, CodingKey {
        case embedURI = "uri"
        case title
        case description
        case thumbnailImageURL = "thumb"
    }
}
