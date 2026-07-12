//
//  AppBskyFeedSearchPosts.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Feed {

    /// The main data model definition for the results of the post search query.
    public struct SearchPosts: Sendable, Codable {

        /// Determines the ranking order for the search results.
        ///
        /// - Note: According to the AT Protocol specifications: "Specifies the ranking order
        /// of results."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.feed.searchPosts`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/searchPosts.json
        public enum SortRanking: String, Sendable, Codable {

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
    public struct SearchPostsOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Find posts matching search criteria, returning
        /// views of those posts. Note that this API endpoint may require authentication (eg, not public) for
        /// some service providers and implementations."
        public let cursor: String?

        /// The number of times the query appears. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Count of search hits. Optional,
        /// may be rounded/truncated, and may not be possible to paginate through all hits."
        public let hitsTotal: Int?

        /// An array of post records in the results.
        public let posts: [PostViewDefinition]
        
        public init(cursor: String?, hitsTotal: Int?, posts: [PostViewDefinition]) {
            self.cursor = cursor
            self.hitsTotal = hitsTotal
            self.posts = posts
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
            self.hitsTotal = try container.decodeIfPresent(Int.self, forKey: .hitsTotal)
            self.posts = try container.decode([AppBskyLexicon.Feed.PostViewDefinition].self, forKey: .posts)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(self.cursor, forKey: .cursor)
            try container.encodeIfPresent(self.hitsTotal, forKey: .hitsTotal)
            try container.encode(self.posts, forKey: .posts)
        }
        
        enum CodingKeys: CodingKey {
            case cursor
            case hitsTotal
            case posts
        }
    }
}
