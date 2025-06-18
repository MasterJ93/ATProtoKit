//
//  AppBskyFeedGetAuthorFeed.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-18.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Feed {

    /// The main data model seeing the user account's posts and reposts.
    public struct GetAuthorFeed: Sendable, Codable {

        /// Indicates the kind of combinations of posts and reposts for the feed's array.
        ///
        /// - Note: According to the AT Protocol specifications: "Combinations of post/repost types to
        /// include in response."
        public enum Filter: String {

            /// Indicates the array of feeds will contain posts with replies.
            case postsWithReplies = "posts_with_replies"

            /// Indicates the array of feeds will contain posts with no replies.
            case postsWithNoReplies = "posts_no_replies"

            /// Indicates the array of feeds will contain posts with media.
            case postsWithMedia = "posts_with_media"

            /// Indicates the array of feeds will contain posts that are threads.
            case postAndAuthorThreads = "posts_and_author_threads"

            /// Indicates the array of the feeds will contain videos.
            case postsWithVideo = "posts_with_video"
        }
    }

    /// An output model for seeing the user account's posts and reposts.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a view of an actor's
    /// 'author feed' (post and reposts by the author). Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getAuthorFeed`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getAuthorFeed.json
    public struct GetAuthorFeedOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of result. Optional.
        public let cursor: String?

        /// An array of like records.
        public let feed: [FeedViewPostDefinition]
    }
}
