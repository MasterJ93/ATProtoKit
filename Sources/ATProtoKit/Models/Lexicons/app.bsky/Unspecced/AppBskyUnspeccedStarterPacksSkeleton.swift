//
//  AppBskyUnspeccedStarterPacksSkeleton.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-30.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// An output model for retrieving the results of a search query for skeleton starter packs.
    ///
    /// - Note: According to the AT Protocol specifications: "Backend Starter Pack search,
    /// returns only skeleton."
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.searchStarterPacksSkeleton`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/searchStarterPacksSkeleton.json
    public struct SearchStarterPackSkeletonOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// The number of times the query appears. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Count of search hits.
        /// Optional, may be rounded/truncated, and may not be possible to paginate through
        /// all hits."
        public let hitsTotal: Int?

        /// An array of skeleton starter packs.
        public let starterPacks: [AppBskyLexicon.Unspecced.SkeletonSearchStarterPackDefinition]
    }
}
