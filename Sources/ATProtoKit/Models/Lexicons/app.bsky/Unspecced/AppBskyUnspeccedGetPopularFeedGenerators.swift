//
//  AppBskyUnspeccedGetPopularFeedGenerators.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// An output model for globally popular feed generators.
    ///
    /// - Note: According to the AT Protocol specifications: "An unspecced view of globally
    /// popular feed generators."
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getPopularFeedGenerators`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getPopularFeedGenerators.json
    public struct GetPopularFeedGeneratorsOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of result. Optional.
        public let cursor: String?

        /// An array of feed generators.
        public let feeds: [AppBskyLexicon.Feed.GeneratorViewDefinition]
        
        public init(cursor: String?, feeds: [AppBskyLexicon.Feed.GeneratorViewDefinition]) {
            self.cursor = cursor
            self.feeds = feeds
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
            self.feeds = try container.decode([AppBskyLexicon.Feed.GeneratorViewDefinition].self, forKey: .feeds)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(self.cursor, forKey: .cursor)
            try container.encode(self.feeds, forKey: .feeds)
        }
        
        enum CodingKeys: CodingKey {
            case cursor
            case feeds
        }
    }
}
