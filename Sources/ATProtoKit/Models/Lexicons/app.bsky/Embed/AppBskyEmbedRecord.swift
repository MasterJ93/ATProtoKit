//
//  AppBskyEmbedRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-17.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
        public struct View: Sendable, Codable, Equatable, Hashable {

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

            // Unions
            /// A reference containing the list of the status of a record.
            public enum RecordViewUnion: ATUnionProtocol, Equatable, Hashable {

                /// A normal record type.
                case viewRecord(AppBskyLexicon.Embed.RecordDefinition.ViewRecord)

                /// A record that may not have been found.
                case viewNotFound(AppBskyLexicon.Embed.RecordDefinition.ViewNotFound)

                /// A record that may have been blocked.
                case viewBlocked(AppBskyLexicon.Embed.RecordDefinition.ViewBlocked)

                /// A record that may have been detached.
                case viewDetached(AppBskyLexicon.Embed.RecordDefinition.ViewDetached)

                /// A generator view.
                case generatorView(AppBskyLexicon.Feed.GeneratorViewDefinition)

                /// A list view.
                case listView(AppBskyLexicon.Graph.ListViewDefinition)

                /// A labeler view.
                case labelerView(AppBskyLexicon.Labeler.LabelerViewDefinition)

                /// A starter pack view.
                case starterPackViewBasic(AppBskyLexicon.Graph.StarterPackViewBasicDefinition)

                /// An unknown case.
                case unknown(String, [String: CodableValue])

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let type = try container.decode(String.self, forKey: .type)

                    switch type {
                        case "app.bsky.embed.record#viewRecord":
                            self = .viewRecord(try AppBskyLexicon.Embed.RecordDefinition.ViewRecord(from: decoder))
                        case "app.bsky.embed.record#viewNotFound":
                            self = .viewNotFound(try AppBskyLexicon.Embed.RecordDefinition.ViewNotFound(from: decoder))
                        case "app.bsky.embed.record#viewBlocked":
                            self = .viewBlocked(try AppBskyLexicon.Embed.RecordDefinition.ViewBlocked(from: decoder))
                        case "app.bsky.embed.record#viewDetached":
                            self = .viewDetached(try AppBskyLexicon.Embed.RecordDefinition.ViewDetached(from: decoder))
                        case "app.bsky.feed.defs#generatorView":
                            self = .generatorView(try AppBskyLexicon.Feed.GeneratorViewDefinition(from: decoder))
                        case "app.bsky.graph.defs#listView":
                            self = .listView(try AppBskyLexicon.Graph.ListViewDefinition(from: decoder))
                        case "app.bsky.labeler.defs#labelerView":
                            self = .labelerView(try AppBskyLexicon.Labeler.LabelerViewDefinition(from: decoder))
                        case "app.bsky.graph.defs#starterPackViewBasic":
                            self = .starterPackViewBasic(try AppBskyLexicon.Graph.StarterPackViewBasicDefinition(from: decoder))
                        default:
                            let singleValueDecodingContainer = try decoder.singleValueContainer()
                            let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                            self = .unknown(type, dictionary)
                    }
                }

                public func encode(to encoder: Encoder) throws {
                    var container = encoder.singleValueContainer()

                    switch self {
                        case .viewRecord(let value):
                            try container.encode(value)
                        case .viewNotFound(let value):
                            try container.encode(value)
                        case .viewBlocked(let value):
                            try container.encode(value)
                        case .viewDetached(let value):
                            try container.encode(value)
                        case .generatorView(let value):
                            try container.encode(value)
                        case .listView(let value):
                            try container.encode(value)
                        case .labelerView(let value):
                            try container.encode(value)
                        case .starterPackViewBasic(let value):
                            try container.encode(value)
                        default:
                            break
                    }
                }

                enum CodingKeys: String, CodingKey {
                    case type = "$type"
                }
            }
        }

        /// A data model for a record definition in an embed.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.record`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/record.json
        public struct ViewRecord: Sendable, Codable, Equatable, Hashable {

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
            public let embeds: [EmbedsUnion]?

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
                self.embeds = try container.decodeIfPresent([EmbedsUnion].self, forKey: .embeds)
                self.indexedAt = try container.decodeDate(forKey: .indexedAt)
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
                try container.encodeDate(self.indexedAt, forKey: .indexedAt)
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

            // Unions
            /// An array of embed views of various types.
            public enum EmbedsUnion: ATUnionProtocol, Equatable, Hashable {

                /// The view of an external embed.
                case embedExternalView(AppBskyLexicon.Embed.ExternalDefinition.View)

                /// The view of an image embed.
                case embedImagesView(AppBskyLexicon.Embed.ImagesDefinition.View)

                /// The view of a record embed.
                case embedRecordView(AppBskyLexicon.Embed.RecordDefinition.View)

                /// The view of a record embed alongside an embed of some compatible media.
                case embedRecordWithMediaView(AppBskyLexicon.Embed.RecordWithMediaDefinition.View)

                /// The view of a video embed.
                case embedVideoView(AppBskyLexicon.Embed.VideoDefinition.View)

                /// An unknown case.
                case unknown(String, [String: CodableValue])

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let type = try container.decode(String.self, forKey: .type)

                    switch type {
                        case "app.bsky.embed.external#view":
                            self = .embedExternalView(try AppBskyLexicon.Embed.ExternalDefinition.View(from: decoder))
                        case "app.bsky.embed.images#view":
                            self = .embedImagesView(try AppBskyLexicon.Embed.ImagesDefinition.View(from: decoder))
                        case "app.bsky.embed.video#view":
                            self = .embedVideoView(try AppBskyLexicon.Embed.VideoDefinition.View(from: decoder))
                        case "app.bsky.embed.record#view":
                            self = .embedRecordView(try AppBskyLexicon.Embed.RecordDefinition.View(from: decoder))
                        case "app.bsky.embed.recordWithMedia#view":
                            self = .embedRecordWithMediaView(try AppBskyLexicon.Embed.RecordWithMediaDefinition.View(from: decoder))
                        default:
                            let singleValueDecodingContainer = try decoder.singleValueContainer()
                            let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                            self = .unknown(type, dictionary)

                    }
                }

                public func encode(to encoder: Encoder) throws {
                    var container = encoder.singleValueContainer()

                    switch self {
                        case .embedExternalView(let value):
                            try container.encode(value)
                        case .embedImagesView(let value):
                            try container.encode(value)
                        case .embedRecordView(let value):
                            try container.encode(value)
                        case .embedRecordWithMediaView(let value):
                            try container.encode(value)
                        case .embedVideoView(let value):
                            try container.encode(value)
                        default:
                            break
                    }
                }

                enum CodingKeys: String, CodingKey {
                    case type = "$type"
                }
            }
        }

        /// A data model for a definition of a record that was unable to be found.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.record`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/record.json
        public struct ViewNotFound: Sendable, Codable, Equatable, Hashable {

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
        public struct ViewBlocked: Sendable, Codable, Equatable, Hashable {

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
        public struct ViewDetached: Sendable, Codable, Equatable, Hashable {

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
