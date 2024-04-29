//
//  BskyEmbedRecordWithMedia.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-27.
//

import Foundation

// MARK: - Main definition
/// The main data model definition for a record embedded with some form of compatible media.
///
/// - Note: According to the AT Protocol specifications: "A representation of a record embedded in a Bluesky record (eg, a post), alongside other compatible embeds. For example, a quote post and image,
/// or a quote post and external URL card."
/// - SeeAlso: This is based on the [`app.bsky.embed.recordWithMedia][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/recordWithMedia.json
public struct EmbedRecordWithMedia: Codable {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public let type: String = "app.bsky.embed.recordWithMedia"
    /// The record that will be embedded.
    public let record: EmbedRecord
    /// The media of a specific type.
    public let media: MediaUnion

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case record
        case media
    }
}

// MARK: -
/// A data model for a definition which contains an embedded record and embedded media.
///
/// - SeeAlso: This is based on the [`app.bsky.embed.recordWithMedia`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/recordWithMedia.json
public struct EmbedRecordWithMediaView: Codable {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public let type: String = "app.bsky.embed.recordWithMedia#view"
    /// The embeded record.
    public let record: EmbedRecordView
    /// The embedded media.
    public let media: MediaViewUnion

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case record
        case media
    }
}

// MARK: - Union Types
/// A reference containing the list of the types of compatible media.
///
/// - SeeAlso: This is based on the [`app.bsky.embed.recordWithMedia`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/recordWithMedia.json
public enum MediaUnion: Codable {
    /// An image that will be embedded.
    case embedImages(EmbedImages)
    /// An external link that will be embedded.
    case embedExternal(EmbedExternal)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(EmbedImages.self) {
            self = .embedImages(value)
        } else if let value = try? container.decode(EmbedExternal.self) {
            self = .embedExternal(value)
        } else {
            throw DecodingError.typeMismatch(PostUnion.self, DecodingError.Context(
                codingPath: decoder.codingPath, debugDescription: "Unknown MediaUnion type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .embedImages(let media):
                try container.encode(media)
            case .embedExternal(let media):
                try container.encode(media)
        }
    }
}

/// A reference containing the list of the types of compatible media that can be viewed.
///
/// - SeeAlso: This is based on the [`app.bsky.embed.recordWithMedia`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/recordWithMedia.json
public enum MediaViewUnion: Codable {
    /// An image that's been embedded.
    case embedImagesView(EmbedImagesView)
    /// An external link that's been embedded.
    case embedExternalView(EmbedExternalView)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(EmbedImagesView.self) {
            self = .embedImagesView(value)
        } else if let value = try? container.decode(EmbedExternalView.self) {
            self = .embedExternalView(value)
        } else {
            throw DecodingError.typeMismatch(PostUnion.self, DecodingError.Context(
                codingPath: decoder.codingPath, debugDescription: "Unknown MediaViewUnion type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .embedImagesView(let mediaView):
                try container.encode(mediaView)
            case .embedExternalView(let mediaView):
                try container.encode(mediaView)
        }
    }
}
