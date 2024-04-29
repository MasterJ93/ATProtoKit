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
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public let type: String = "app.bsky.embed.record#view"
    /// The record of a specific type.
    public let record: RecordViewUnion

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case record
    }
}

/// A data model for a record definition in an embed.
///
/// - SeeAlso: This is based on the [`app.bsky.embed.record`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/record.json
public struct ViewRecord: Codable {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public let type: String = "app.bsky.embed.record#viewRecord"
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
    /// The number of replies for the record. Optional.
    public let replyCount: Int?
    /// The number of reposts for the record. Optional.
    public let repostCount: Int?
    /// The number of likes for the record. Optional.
    public let likeCount: Int?
    /// An array of embed views of various types.
    public let embeds: [EmbedViewUnion]?
    /// The date the record was last indexed.
    @DateFormatting public var indexedAt: Date

    public init(recordURI: String, cidHash: String, author: ActorProfileViewBasic, value: UnknownType, labels: [Label]?, replyCount: Int?,
                repostCount: Int?, likeCount: Int?, embeds: [EmbedViewUnion]?, indexedAt: Date) {
        self.recordURI = recordURI
        self.cidHash = cidHash
        self.author = author
        self.value = value
        self.labels = labels
        self.replyCount = replyCount
        self.repostCount = repostCount
        self.likeCount = likeCount
        self.embeds = embeds
        self._indexedAt = DateFormatting(wrappedValue: indexedAt)
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.recordURI = try container.decode(String.self, forKey: .recordURI)
        self.cidHash = try container.decode(String.self, forKey: .cidHash)
        self.author = try container.decode(ActorProfileViewBasic.self, forKey: .author)
        self.value = try container.decode(UnknownType.self, forKey: .value)
        self.labels = try container.decodeIfPresent([Label].self, forKey: .labels)
        self.replyCount = try container.decodeIfPresent(Int.self, forKey: .replyCount)
        self.repostCount = try container.decodeIfPresent(Int.self, forKey: .repostCount)
        self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)
        self.embeds = try container.decodeIfPresent([EmbedViewUnion].self, forKey: .embeds)
        self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.recordURI, forKey: .recordURI)
        try container.encode(self.cidHash, forKey: .cidHash)
        try container.encode(self.author, forKey: .author)
        try container.encode(self.value, forKey: .value)
        try container.encodeIfPresent(self.labels, forKey: .labels)
        try container.encodeIfPresent(self.replyCount, forKey: .replyCount)
        try container.encodeIfPresent(self.repostCount, forKey: .repostCount)
        try container.encodeIfPresent(self.likeCount, forKey: .likeCount)
        try container.encodeIfPresent(self.embeds, forKey: .embeds)
        try container.encode(self._indexedAt, forKey: .indexedAt)
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case recordURI = "uri"
        case cidHash = "cid"
        case author
        case value
        case labels
        case replyCount
        case repostCount
        case likeCount
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
    /// A generator view.
    case generatorView(FeedGeneratorView)
    /// A list view.
    case listView(GraphListView)
    /// A labeler view.
    case labelerView(LabelerView)

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
        } else if let value = try? container.decode(LabelerView.self) {
            self = .labelerView(value)
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
            case .labelerView(let labelerView):
                try container.encode(labelerView)
        }
    }
}
