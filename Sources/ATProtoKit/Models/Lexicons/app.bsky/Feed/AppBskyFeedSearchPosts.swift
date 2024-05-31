//
//  AppBskyFeedSearchPosts.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Feed {

    /// The main data model definition for the results of the post search query.
    public struct SearchPosts: Codable {

        /// Determines the ranking order for the search results.
        ///
        /// - Note: According to the AT Protocol specifications: "Specifies the ranking order
        /// of results."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.feed.searchPosts`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/searchPosts.json
        public enum SortRanking: String {

            /// Indicates the results will be sorted by the top posts.
            case top

            /// Indicates the results will be sorted by the latest posts.
            case latest
        }
    }

    /// An output model for the results of the post search query.
    ///
    /// - Note: According to the AT Protocol specifications: "Find posts matching search criteria,
    /// returning views of those posts."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.searchPosts`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/searchPosts.json
    public struct SearchPostsOutput: Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional pagination mechanism;
        /// may not necessarily allow scrolling through entire result set."
        public let cursor: String?

        /// The number of times the query appears. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Count of search hits. Optional,
        /// may be rounded/truncated, and may not be possible to paginate through all hits."
        public let hitsTotal: Int?

        /// An array of post records in the results.
        public let posts: [PostViewDefinition]
    }
}
