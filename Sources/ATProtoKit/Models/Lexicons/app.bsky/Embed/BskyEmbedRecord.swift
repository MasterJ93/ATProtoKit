//
//  BskyEmbedRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-26.
//

import Foundation

// MARK: - Main definition
/// The main data model definition for record embeds.
///
/// - Note: According to the AT Protocol specifications: "A representation of a record embedded in a Bluesky record (eg, a post). For example, a quote-post, or sharing a feed generator record."
/// - SeeAlso: This is based on the [`app.bsky.embed.record`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/record.json
public struct EmbedRecord: Codable {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public let type: String = "app.bsky.embed.record"
    /// The strong reference of the record.
    public let record: StrongReference

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case record
    }
}

// MARK: -
/// A data model for a view definition.
///
/// - SeeAlso: This is based on the [`app.bsky.embed.record`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/record.json
public struct EmbedRecordView: Codable {
    /// The record of a specific type.
    public let record: RecordViewUnion

    public init(record: RecordViewUnion) {
        self.record = record
    }
}

/// A data model for a record definition in an embed.
///
/// - SeeAlso: This is based on the [`app.bsky.embed.record`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/record.json
public struct ViewRecord: Codable {
    /// The URI of the record.
    public let recordURI: String
    /// The CID of the record.
    public let cidHash: String
    /// The creator of the record.
    public let author: ActorProfileViewBasic
    // TODO: Find out what specific type falls under this variable.
    /// The value of the record.
    ///
    /// - Note: According to the AT Protocol specifications: "The record data itself."
    public let value: UnknownType
    /// An array of labels attached to the record.
    public let labels: [Label]?
    /// An array of embed views of various types.
    public let embeds: [EmbedViewUnion]?
    /// The date the record was last indexed.
    @DateFormatting public var indexedAt: Date

    enum CodingKeys: String, CodingKey {
        case recordURI = "uri"
        case cidHash = "cid"
        case author
        case value = "value"
        case labels = "labels"
        case embeds = "embeds"
        case indexedAt
    }
}

/// A data model for a definition of a record that was unable to be found.
///
/// - SeeAlso: This is based on the [`app.bsky.embed.record`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/record.json
public struct ViewNotFound: Codable {
    /// The URI of the record.
    public let recordURI: String
    /// Indicates whether the record was found.
    public let isRecordNotFound: Bool

    enum CodingKeys: String, CodingKey {
        case recordURI = "uri"
        case isRecordNotFound = "notFound"
    }
}

/// A data model for a definition of a record that has been blocked.
///
/// - SeeAlso: This is based on the [`app.bsky.embed.record`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/record.json
public struct ViewBlocked: Codable {
    /// The URI of the record.
    public let recordURI: String
    /// Indicates whether the record has been blocked.
    public let isRecordBlocked: Bool
    /// The author of the record.
    public let recordAuthor: FeedBlockedAuthor

    enum CodingKeys: String, CodingKey {
        case recordURI = "uri"
        case isRecordBlocked = "blocked"
        case recordAuthor = "author"
    }
}

// MARK: - Union types
/// A reference containing the list of the status of a record.
///
/// - SeeAlso: This is based on the [`app.bsky.embed.record`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/record.json
public enum RecordViewUnion: Codable {
    /// A normal record type.
    case viewRecord(ViewRecord)
    /// A record that may not have been found.
    case viewNotFound(ViewNotFound)
    /// A record that may have been blocked.
    case viewBlocked(ViewBlocked)
    /// A record that contains a generator view.
    case generatorView(FeedGeneratorView)
    /// A record that contains a list view.
    case listView(GraphListView)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(ViewRecord.self) {
            self = .viewRecord(value)
        } else if let value = try? container.decode(ViewNotFound.self) {
            self = .viewNotFound(value)
        } else if let value = try? container.decode(ViewBlocked.self) {
            self = .viewBlocked(value)
        } else if let value = try? container.decode(FeedGeneratorView.self) {
            self = .generatorView(value)
        } else if let value = try? container.decode(GraphListView.self) {
            self = .listView(value)
        } else {
            throw DecodingError.typeMismatch(RecordViewUnion.self, DecodingError.Context(codingPath: decoder.codingPath,
                                                                                         debugDescription: "Unknown RecordViewUnion type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .viewRecord(let viewRecord):
                try container.encode(viewRecord)
            case .viewNotFound(let viewRecord):
                try container.encode(viewRecord)
            case .viewBlocked(let viewRecord):
                try container.encode(viewRecord)
            case .generatorView(let viewRecord):
                try container.encode(viewRecord)
            case .listView(let viewRecord):
                try container.encode(viewRecord)
        }
    }
}
