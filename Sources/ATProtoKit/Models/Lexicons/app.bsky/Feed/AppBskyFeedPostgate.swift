//
//  AppBskyFeedPostgate.swift
//
//
//  Created by Christopher Jr Riley on 2024-08-23.
//

import Foundation

extension AppBskyLexicon.Feed {

    /// A record model for the rules of a post's interaction.
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

        /// An array of URIs belonging to posts that the `postURI`'s auther has detached. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "List of AT-URIs embedding this
        /// post that the author has detached from."
        public let detachedEmbeddingURIs: [String]?

        /// An array of rules for embedding the post. Optional.
        public let embeddingRules: [ATUnion.EmbeddingRulesUnion]?

        public init(createdAt: Date, postURI: String, detachedEmbeddingURIs: [String]?, embeddingRules: [ATUnion.EmbeddingRulesUnion]?) {
            self.createdAt = createdAt
            self.postURI = postURI
            self.detachedEmbeddingURIs = detachedEmbeddingURIs
            self.embeddingRules = embeddingRules
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.createdAt = try decodeDate(from: container, forKey: .createdAt)
            self.postURI = try container.decode(String.self, forKey: .postURI)
            self.detachedEmbeddingURIs = try container.decodeIfPresent([String].self, forKey: .detachedEmbeddingURIs)
            self.embeddingRules = try container.decodeIfPresent([ATUnion.EmbeddingRulesUnion].self, forKey: .embeddingRules)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try encodeDate(self.createdAt, with: &container, forKey: .createdAt)
            try container.encode(self.postURI, forKey: .postURI)

            try truncatedEncodeIfPresent(self.detachedEmbeddingURIs, withContainer: &container, forKey: .detachedEmbeddingURIs, upToArrayLength: 50)

            try truncatedEncodeIfPresent(self.embeddingRules, withContainer: &container, forKey: .embeddingRules, upToArrayLength: 5)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case createdAt
            case postURI = "post"
            case detachedEmbeddingURIs = "detachedEmbeddingUris"
            case embeddingRules
        }
    }
}
