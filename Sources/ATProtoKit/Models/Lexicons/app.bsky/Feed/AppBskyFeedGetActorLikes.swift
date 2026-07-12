//
//  AppBskyFeedGetActorLikes.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-18.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Feed {

    /// An output model for seeing all of a user account's likes.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of posts liked by an actor.
    /// Requires auth, actor must be the requesting account."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getActorLikes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getActorLikes.json
    public struct GetActorLikesOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of result. Optional.
        public let cursor: String?

        /// An array of like records.
        public let feed: [AppBskyLexicon.Feed.FeedViewPostDefinition]
        
        public init(cursor: String?, feed: [AppBskyLexicon.Feed.FeedViewPostDefinition]) {
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
