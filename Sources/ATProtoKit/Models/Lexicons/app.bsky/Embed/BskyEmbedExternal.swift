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
/// - Note: This is based on the `app.bsky.embed.external` lexicon.
///
/// The lexicon can be viewed in their [GitHub repo][github].
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/external.json
public struct EmbedExternal: Codable {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public let type: String = "app.bsky.embed.external"
    /// The external content needed to be embeeded.
    ///
    /// - Note: From the AT Protocol specifications: "A representation of some externally linked content (eg, a URL and 'card'), embedded in a Bluesky record (eg, a post)."
    public let external: External

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case external
    }
}
// MARK: -
/// A data model for an external definition.
///
/// - Note: This is based on the `app.bsky.embed.external` lexicon.
///
/// The lexicon can be viewed in their [GitHub repo][github].
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
    public let thumbnail: Data
}

/// A data model for an external view definition.
///
/// - Note: This is based on the `app.bsky.embed.external` lexicon.
///
/// The lexicon can be viewed in their [GitHub repo][github].
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/external.json
public struct EmbedExternalView: Codable {
    /// The external content embedded in a post.
    public let external: ViewExternal
}

/// A data model for a definition for the external content.
public struct ViewExternal: Codable {
    /// The URI of the external content.
    public let embedURI: String
    /// The title of the external content.
    public let title: String
    /// The description of the external content.
    public let description: String
    /// The thumbnail image of the external content.
    public let thumbnail: String?
}
