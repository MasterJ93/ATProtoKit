//
//  AppBskyFeedGetAuthorFeed.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-18.
//

import Foundation

extension AppBskyLexicon.Feed {

    /// The main data model definition for the output of seeing the user account's posts
    /// and reposts.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a view of an actor's
    /// 'author feed' (post and reposts by the author). Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getAuthorFeed`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getAuthorFeed.json
    public struct GetAuthorFeedOutput: Codable {

        /// The mark used to indicate the starting point for the next set of result. Optional.
        public let cursor: String?

        /// An array of like records.
        public let feed: [FeedViewPostDefinition]
    }
    
    /// Indicates the kind of combinations of posts and reposts for the feed's array.
    ///
    /// - Note: According to the AT Protocol specifications: "Combinations of post/repost types to
    /// include in response."
    public enum GetAuthorFeedFilter: String {

        /// Indicates the array of feeds will contain posts with replies.
        case postsWithReplies = "posts_with_replies"

        /// Indicates the array of feeds will contain posts with no replies.
        case postsWithNoReplies = "posts_no_replies"

        /// Indicates the array of feeds will contain posts with media.
        case postsWithMedia = "posts_with_media"

        /// Indicates the array of feeds will contain posts that are threads.
        case postAndAuthorThreads = "posts_and_author_threads"
    }
}
