//
//  AppBskyFeedGetTimeline.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Feed {

    /// An output model for getting the user account's timeline.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a view of the requesting account's
    /// home timeline. This is expected to be some form of reverse-chronological feed."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getTimeline`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getTimeline.json
    public struct GetTimelineOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// Cursor identifying the newest item in this page. Pass it as since on a later request
        /// to fetch only newer content. Optional.
        public let startCursor: String?

        /// An array of post records.
        public let feed: [FeedViewPostDefinition]
        
        public init(cursor: String?, startCursor: String? = nil, feed: [FeedViewPostDefinition]) {
            self.cursor = cursor
            self.startCursor = startCursor
            self.feed = feed
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
            self.startCursor = try container.decodeIfPresent(String.self, forKey: .startCursor)
            self.feed = try container.decode([AppBskyLexicon.Feed.FeedViewPostDefinition].self, forKey: .feed)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(self.cursor, forKey: .cursor)
            try container.encodeIfPresent(self.startCursor, forKey: .startCursor)
            try container.encode(self.feed, forKey: .feed)
        }
        
        enum CodingKeys: CodingKey {
            case cursor
            case startCursor
            case feed
        }
    }
}
