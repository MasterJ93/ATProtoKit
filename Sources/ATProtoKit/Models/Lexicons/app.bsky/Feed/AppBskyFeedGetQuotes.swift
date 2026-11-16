//
//  AppBskyFeedGetQuotes.swift
//
//
//  Created by Christopher Jr Riley on 2024-08-23.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Feed {

    /// The main data model definition for getting the quote posts of a given post.
    public struct GetQuotes: Sendable, Codable {

        /// Determines the ordering of the quote posts.
        ///
        /// - Note: According to the AT Protocol specifications: "Ordering of results. 'latest'
        /// (default when unset) is newest first; 'top' orders quotes by their like count."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.feed.getQuotes`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/packages/api/lexicons/app/bsky/feed/getQuotes.json
        public enum Sort: String, Sendable, Codable {

            /// Indicates the results will be sorted by the latest quote posts.
            case latest

            /// Indicates the results will be sorted by the quote posts' like count.
            case top
        }
    }

    /// An output model for getting the quote posts of a given post.
    ///
    /// - Note: According to the AT Protocol specifications: "Get posts in a thread. Does not require
    /// auth, but additional metadata and filtering will be applied for authed requests."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getPostThread`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getPostThread.json
    public struct GetQuotesOutput: Sendable, Codable {

        /// The URI of the given post.
        public let postURI: String

        /// The CID hash of the given post.
        public let postCID: String?

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of quote posts.
        public let posts: [AppBskyLexicon.Feed.PostViewDefinition]

        enum CodingKeys: String, CodingKey {
            case postURI = "uri"
            case postCID = "cid"
            case cursor
            case posts
        }
    }
}
