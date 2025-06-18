//
//  AppBskyFeedPostgate.swift
//
//
//  Created by Christopher Jr Riley on 2024-08-23.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Feed {

    /// A record model for the rules of a post's interaction.
    ///
    /// - Important: When creating this record, be sure that the record key of a
    /// ``AppBskyLexicon/Feed/PostRecord`` is the same as the record key of this record.
    ///
    /// - Note: According to the AT Protocol specifications: "Record defining interaction rules for
    /// a post. The record key (rkey) of the postgate record must match the record key of the post,
    /// and that record must be in the same repository."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.postgate`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/postgate.json
    public struct PostgateRecord: ATRecordProtocol, Sendable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.feed.postgate"

        /// The date and time the post was created.
        public let createdAt: Date

        /// The URI of the post.
        public let postURI: String

        /// An array of URIs belonging to posts that the `postURI`'s author has detached. Optional.
        ///
        /// - Important: Current maximum length is 50 items.
        ///
        /// - Note: According to the AT Protocol specifications: "List of AT-URIs embedding this
        /// post that the author has detached from."
        public let detachedEmbeddingURIs: [String]?

        /// An array of rules for embedding the post. Optional.
        ///
        /// - Important: Current maximum length is 5 items.
        public let embeddingRules: [EmbeddingRulesUnion]?

        public init(createdAt: Date, postURI: String, detachedEmbeddingURIs: [String]?, embeddingRules: [EmbeddingRulesUnion]?) {
            self.createdAt = createdAt
            self.postURI = postURI
            self.detachedEmbeddingURIs = detachedEmbeddingURIs
            self.embeddingRules = embeddingRules
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.createdAt = try container.decodeDate(forKey: .createdAt)
            self.postURI = try container.decode(String.self, forKey: .postURI)
            self.detachedEmbeddingURIs = try container.decodeIfPresent([String].self, forKey: .detachedEmbeddingURIs)
            self.embeddingRules = try container.decodeIfPresent([EmbeddingRulesUnion].self, forKey: .embeddingRules)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(Self.type, forKey: .type)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
            try container.encode(self.postURI, forKey: .postURI)
            try container.truncatedEncodeIfPresent(self.detachedEmbeddingURIs, forKey: .detachedEmbeddingURIs, upToArrayLength: 50)
            try container.truncatedEncodeIfPresent(self.embeddingRules, forKey: .embeddingRules, upToArrayLength: 5)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case createdAt
            case postURI = "post"
            case detachedEmbeddingURIs = "detachedEmbeddingUris"
            case embeddingRules
        }

        /// A marker that disables the embedding of this post.
        ///
        /// - Note: According to the AT Protocol specifications: "Disables embedding of this post."
        public struct DisableRule: Codable, Sendable, Equatable, Hashable {

            public let type: String = "app.bsky.feed.postgate#disableRule"

            public init() {}

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(self.type, forKey: .type)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }

        /// An array of rules for embedding the post.
        public enum EmbeddingRulesUnion: ATUnionProtocol, Equatable, Hashable {

            /// A marker that disables the embedding of this post.
            case disabledRule(AppBskyLexicon.Feed.PostgateRecord.DisableRule)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decode(String.self, forKey: .type)

                switch type {
                    case "app.bsky.feed.postgate#disableRule":
                        self = .disabledRule(try AppBskyLexicon.Feed.PostgateRecord.DisableRule(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type, dictionary)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .disabledRule(let disabledRule):
                        try container.encode(disabledRule)
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
