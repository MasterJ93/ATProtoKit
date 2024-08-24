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
    public struct PostgateRecord: ATRecordProtocol {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static var type: String = "app.bsky.feed.postgate"

        /// The date and time the post was created.
        @DateFormatting public var createdAt: Date

        /// The URI of the post.
        public let postURI: String

        /// An array of URIs belonging to posts that the `postURI`'s auther has detached. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "List of AT-URIs embedding this
        /// post that the author has detached from."
        public let detachedEmbeddingURIs: [String]?

        /// An array of rules for embedding the post. Optional.
        public let embeddingRules: [ATUnion.EmbeddingRulesUnion]?

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self._createdAt, forKey: .createdAt)
            try container.encode(self.postURI, forKey: .postURI)

            try truncatedEncodeIfPresent(self.detachedEmbeddingURIs, withContainer: &container, forKey: .detachedEmbeddingURIs, upToArrayLength: 50)

            try truncatedEncodeIfPresent(self.embeddingRules, withContainer: &container, forKey: .embeddingRules, upToArrayLength: 5)
        }

        enum CodingKeys: String, CodingKey {
            case createdAt
            case postURI = "post"
            case detachedEmbeddingURIs = "detachedEmbeddingUris"
            case embeddingRules
        }
    }
}
