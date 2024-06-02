//
//  AppBskyUnspeccedSearchPostsSkeleton.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Unspecced {

    /// The main data model for retrieving the skeleton results of posts.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.searchPostsSkeleton`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/searchPostsSkeleton.json
    public struct SearchPostsSkeleton: Codable {

        /// Determines the ranking order for the search results.
        ///
        /// - Note: According to the AT Protocol specifications: "Specifies the ranking order
        /// of results."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.searchPostsSkeleton`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/searchPostsSkeleton.json
        public enum Sort: String {

            /// Indicates the results will be sorted by the top posts.
            case top

            /// Indicates the results will be sorted by the latest posts.
            case latest
        }
    }

    /// An output model for retrieving the skeleton results of posts.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Backend Posts search, returns
    /// only skeleton."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.searchPostsSkeleton`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/searchPostsSkeleton.json
    public struct SearchPostsSkeletonOutput: Codable {

        /// The mark used to indicate the starting point for the next set of result. Optional.
        public let cursor: String?

        /// The number of search results.
        ///
        /// This number may not be completely reliable, as it can be rounded or truncated.
        /// This number doesn't reflect all of the possible posts that can be seen.
        ///
        /// - Note: According to the AT Protocol specifications: "Count of search hits.
        /// Optional, may be rounded/truncated, and may not be possible to paginate through
        /// all hits."
        public let hitsTotal: Int?

        /// An array of posts.
        public let posts: [SkeletonSearchPostDefinition]
    }
}
