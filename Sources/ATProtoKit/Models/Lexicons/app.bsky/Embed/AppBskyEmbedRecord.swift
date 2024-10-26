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
    public struct RecordDefinition: Sendable, Codable {

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
            public let recordURI: String

            /// The CID of the record.
            public let cidHash: String

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
            @DateFormatting public var indexedAt: Date

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
                case quoteCount
                case embeds = "embeds"
                case indexedAt
            }
        }

        /// A data model for a definition of a record that was unable to be found.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.record`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/record.json
        public struct ViewNotFound: Sendable, Codable {

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
        public struct ViewBlocked: Sendable, Codable {

            /// The URI of the record.
            public let recordURI: String

            /// Indicates whether the record has been blocked.
            public let isRecordBlocked: Bool

            /// The author of the record.
            public let recordAuthor: AppBskyLexicon.Feed.BlockedAuthorDefinition

            enum CodingKeys: String, CodingKey {
                case recordURI = "uri"
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

            /// The URI of the record.
            public let postURI: String

            /// Indicates whether the record was detached.
            public let isRecordDetached: Bool

            enum CodingKeys: String, CodingKey {
                case postURI = "uri"
                case isRecordDetached = "detached"
            }
        }
    }
}
