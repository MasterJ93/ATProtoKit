//
//  AppBskyFeedGetListFeed.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-18.
//

import Foundation

extension AppBskyLexicon.Feed {

    /// The main data model definition for the output of retireving recent posts and reposts from
    /// a given feed.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a feed of recent posts from a
    /// list (posts and reposts from any actors on the list). Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getListFeed`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getListFeed.json
    public struct GetListFeedOutput: Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of posts in a feed.
        public let feed: [FeedViewPostDefinition]
    }
}
