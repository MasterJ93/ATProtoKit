//
//  AppBskyUnspeccedGetTrendingTopics.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-30.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// An output model for retrieving the topics that are trending in Bluesky.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may change
    /// or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "DID of the account making the
    /// request (not included for public/unauthenticated queries). Used to boost followed accounts
    /// in ranking."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getTrendingTopics`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getTrendingTopics.json
    public struct GetTrendingTopicsOutput: Sendable, Codable {

        /// An array of trending topics.
        public let topics: [AppBskyLexicon.Unspecced.TrendingTopicDefinition]

        /// An array of suggested feeds.
        public let suggestedTopics: [AppBskyLexicon.Unspecced.TrendingTopicDefinition]

        enum CodingKeys: String, CodingKey {
            case topics
            case suggestedTopics = "suggested"
        }
    }
}
