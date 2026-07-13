//
//  AppBskyFeedGetFeed.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-18.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Feed {

    /// An output model for viewing the selected feed generator.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a hydrated feed from an actor's
    /// selected feed generator. Implemented by App View."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getFeed`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getFeed.json
    public struct GetFeedOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of result. Optional.
        public let cursor: String?

        /// An array of posts in the feed.
        public let feed: [FeedViewPostDefinition]
        
        public init(cursor: String?, feed: [FeedViewPostDefinition]) {
            self.cursor = cursor
            self.feed = feed
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
            self.feed = try container.decode([AppBskyLexicon.Feed.FeedViewPostDefinition].self, forKey: .feed)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(self.cursor, forKey: .cursor)
            try container.encode(self.feed, forKey: .feed)
        }
        
        enum CodingKeys: CodingKey {
            case cursor
            case feed
        }
    }
}
