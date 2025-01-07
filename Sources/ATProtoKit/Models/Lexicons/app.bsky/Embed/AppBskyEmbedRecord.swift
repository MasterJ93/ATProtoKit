//
//  AppBskyEmbedRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-17.
//

import Foundation

extension AppBskyLexicon.Embed {

    /// A definition model for record embeds.
    ///
    /// - Note: According to the AT Protocol specifications: "A representation of a record embedded
    /// in a Bluesky record (eg, a post). For example, a quote-post, or sharing a
    /// feed generator record."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.embed.record`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/record.json
    public struct RecordDefinition: Sendable, Codable, Equatable, Hashable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.embed.record"

        /// The strong reference of the record.
        public let record: ComAtprotoLexicon.Repository.StrongReference

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case record
        }

        // Enums
        /// A data model for a view definition.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.record`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/record.json
        public struct View: Sendable, Codable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.record#view"

            /// The record of a specific type.
            public let record: ATUnion.RecordViewUnion

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
        public struct ViewRecord: Sendable, Codable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.record#viewRecord"

            /// The URI of the record.
            public let uri: String

            /// The CID hash of the record.
            public let cid: String

            /// The creator of the record.
            public let author: AppBskyLexicon.Actor.ProfileViewBasicDefinition

            /// The value of the record.
            ///
            /// - Note: According to the AT Protocol specifications: "The record data itself."
            public let value: UnknownType

            /// An array of labels attached to the record.
            public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

            /// The number of replies for the record. Optional.
            public let replyCount: Int?

            /// The number of reposts for the record. Optional.
            public let repostCount: Int?

            /// The number of likes for the record. Optional.
            public let likeCount: Int?

            /// The number of quotes for the record. Optional.
            public let quoteCount: Int?

            /// An array of embed views of various types.
            public let embeds: [ATUnion.EmbedViewUnion]?

            /// The date the record was last indexed.
            public let indexedAt: Date

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.uri = try container.decode(String.self, forKey: .uri)
                self.cid = try container.decode(String.self, forKey: .cid)
                self.author = try container.decode(AppBskyLexicon.Actor.ProfileViewBasicDefinition.self, forKey: .author)
                self.value = try container.decode(UnknownType.self, forKey: .value)
                self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: .labels)
                self.replyCount = try container.decodeIfPresent(Int.self, forKey: .replyCount)
                self.repostCount = try container.decodeIfPresent(Int.self, forKey: .repostCount)
                self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)
                self.quoteCount = try container.decodeIfPresent(Int.self, forKey: .quoteCount)
                self.embeds = try container.decodeIfPresent([ATUnion.EmbedViewUnion].self, forKey: .embeds)
                self.indexedAt = try decodeDate(from: container, forKey: .indexedAt)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(self.uri, forKey: .uri)
                try container.encode(self.cid, forKey: .cid)
                try container.encode(self.author, forKey: .author)
                try container.encode(self.value, forKey: .value)
                try container.encodeIfPresent(self.labels, forKey: .labels)
                try container.encodeIfPresent(self.replyCount, forKey: .replyCount)
                try container.encodeIfPresent(self.repostCount, forKey: .repostCount)
                try container.encodeIfPresent(self.likeCount, forKey: .likeCount)
                try container.encodeIfPresent(self.quoteCount, forKey: .quoteCount)
                try container.encodeIfPresent(self.embeds, forKey: .embeds)
                try encodeDate(self.indexedAt, with: &container, forKey: .indexedAt)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case uri
                case cid
                case author
                case value
                case labels
                case replyCount
                case repostCount
                case likeCount
                case quoteCount
                case embeds
                case indexedAt
            }
        }

        /// A data model for a definition of a record that was unable to be found.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.record`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/record.json
        public struct ViewNotFound: Sendable, Codable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.record#viewNotFound"

            /// The URI of the record.
            public let uri: String

            /// Indicates whether the record was found.
            public let isRecordNotFound: Bool

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case uri
                case isRecordNotFound = "notFound"
            }
        }

        /// A data model for a definition of a record that has been blocked.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.record`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/record.json
        public struct ViewBlocked: Sendable, Codable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.record#viewBlocked"

            /// The URI of the record.
            public let uri: String

            /// Indicates whether the record has been blocked.
            public let isRecordBlocked: Bool

            /// The author of the record.
            public let recordAuthor: AppBskyLexicon.Feed.BlockedAuthorDefinition

            enum CodingKeys: String, CodingKey {
                case uri
                case isRecordBlocked = "blocked"
                case recordAuthor = "author"
            }
        }

        /// A data model for a definition of a record that has been detached.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.record`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/record.json
        public struct ViewDetached: Sendable, Codable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.record#viewDetached"

            /// The URI of the record.
            public let postURI: String

            /// Indicates whether the record was detached.
            public let isRecordDetached: Bool

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case postURI = "uri"
                case isRecordDetached = "detached"
            }
        }
    }
}
