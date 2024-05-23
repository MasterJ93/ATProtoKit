//
//  AppBskyFeedGetFeed.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-18.
//

import Foundation

extension AppBskyLexicon.Feed {

    /// An output model for viewing the selected feed generator.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a hydrated feed from an actor's
    /// selected feed generator. Implemented by App View."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getFeed`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getFeed.json
    public struct GetFeedOutput: Codable {

        /// The mark used to indicate the starting point for the next set of result. Optional.
        public let cursor: String?

        /// An array of posts in the feed.
        public let feed: [FeedViewPostDefinition]
    }
}
