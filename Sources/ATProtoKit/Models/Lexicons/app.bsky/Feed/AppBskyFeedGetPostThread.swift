//
//  AppBskyFeedGetPostThread.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Feed {

    /// The main data model definition for the output of retrieving a post thread.
    ///
    /// - Note: According to the AT Protocol specifications: "Get posts in a thread. Does not require
    /// auth, but additional metadata and filtering will be applied for authed requests."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getPostThread`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getPostThread.json
    public struct GetPostThreadOutput: Codable {

        /// The post thread itself.
        public let thread: ATUnion.FeedGetPostThreadUnion
    }
}
