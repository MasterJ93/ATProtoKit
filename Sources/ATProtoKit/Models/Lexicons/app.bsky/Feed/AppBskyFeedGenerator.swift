//
//  AppBskyFeedGenerator.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-18.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Feed {

    /// A record model for a feed generator record.
    ///
    /// - Note: According to the AT Protocol specifications: "Record declaring of the existence of
    /// a feed generator, and containing metadata about it. The record can exist in
    /// any repository."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.generator`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/generator.json
    public struct GeneratorRecord: ATRecordProtocol, Sendable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.feed.generator"

        /// The decentralized identifier (DID) of the feed.
        public let feedDID: String

        /// The display name of the feed.
        ///
        /// - Important: Current maximum lenth is 24 characters. This library will automatically
        /// truncate the `String` to the maximum length if it does go over the limit.
        public let displayName: String

        /// The description of the feed. Optional.
        ///
        /// - Important: Current maximum length is 300 characters.
        public let description: String?

        /// An array of the facets within the feed generator's description. Optional.
        public let descriptionFacets: [AppBskyLexicon.RichText.Facet]?

        /// The URL of the avatar image. Optional.
        ///
        /// - Note: Only JPEGs and PNGs are accepted.
        ///
        /// - Important: Current maximum file size 1,000,000 bytes (1 MB).
        public let avatarImageBlob: ComAtprotoLexicon.Repository.BlobContainer??

        /// Indicates whether the feed generator can accept interactions.
        ///
        /// - Note: According to the AT Protocol specifications: "Declaration that a feed accepts
        /// feedback interactions from a client through `app.bsky.feed.sendInteractions`"
        public let canAcceptInteractions: Bool?

        /// An array of labels created by the user. Optional.
        public let labels: LabelsUnion?

        /// The content mode for the feed generator. Optional.
        public let contentMode: ContentMode?

        /// The date and time the feed was created.
        public let createdAt: Date

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.feedDID = try container.decode(String.self, forKey: .feedDID)
            self.displayName = try container.decode(String.self, forKey: .displayName)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.descriptionFacets = try container.decodeIfPresent([AppBskyLexicon.RichText.Facet].self, forKey: .descriptionFacets)
            self.avatarImageBlob = try container.decodeIfPresent(ComAtprotoLexicon.Repository.BlobContainer?.self, forKey: .avatarImageBlob)
            self.canAcceptInteractions = try container.decodeIfPresent(Bool.self, forKey: .canAcceptInteractions)
            self.labels = try container.decodeIfPresent(LabelsUnion.self, forKey: .labels)
            self.contentMode = try container.decodeIfPresent(ContentMode.self, forKey: .contentMode)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.feedDID, forKey: .feedDID)
            try container.truncatedEncode(self.displayName, forKey: .description, upToCharacterLength: 24)
            try container.truncatedEncodeIfPresent(self.description, forKey: .description, upToCharacterLength: 300)
            try container.encodeIfPresent(self.descriptionFacets, forKey: .descriptionFacets)
            try container.encodeIfPresent(self.avatarImageBlob, forKey: .avatarImageBlob)
            try container.encodeIfPresent(self.canAcceptInteractions, forKey: .canAcceptInteractions)
            try container.encodeIfPresent(self.labels, forKey: .labels)
            try container.encodeIfPresent(self.contentMode, forKey: .contentMode)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case feedDID = "did"
            case displayName
            case description
            case descriptionFacets
            case avatarImageBlob = "avatar"
            case canAcceptInteractions = "acceptsInteractions"
            case labels
            case contentMode
            case createdAt
        }

        /// The content mode for the feed generator.
        public enum ContentMode: String, Sendable, Codable {

            /// Declares the feed generator supports any post type.
            case unspecified = "app.bsky.feed.defs#contentModeUnspecified"

            /// Declares the feed generator returns posts with embeds from `app.bsky.embed.video`.
            case video = "app.bsky.feed.defs#contentModeVideo"
        }

        // Unions
        /// An array of labels created by the user.
        public enum LabelsUnion: ATUnionProtocol, Equatable, Hashable {

            /// An array of user-defined labels.
            case selfLabels(ComAtprotoLexicon.Label.SelfLabelsDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "com.atproto.label.defs#selfLabels":
                        self = .selfLabels(try ComAtprotoLexicon.Label.SelfLabelsDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .selfLabels(let value):
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
}
