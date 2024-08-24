//
//  AppBskyFeedGetQuotes.swift
//
//
//  Created by Christopher Jr Riley on 2024-08-23.
//

import Foundation

extension AppBskyLexicon.Feed {

    /// An output model for getting the quote posts of a given post.
    ///
    /// - Note: According to the AT Protocol specifications: "Get posts in a thread. Does not require
    /// auth, but additional metadata and filtering will be applied for authed requests."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getPostThread`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getPostThread.json
    public struct GetQuotesOutput: Codable {

        /// The URI of the given post.
        public let postURI: String

        /// The CID hash of the given post.
        public let postCID: String?

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of quote posts.
        public let posts: [AppBskyLexicon.Feed.PostViewDefinition]
    }
}
