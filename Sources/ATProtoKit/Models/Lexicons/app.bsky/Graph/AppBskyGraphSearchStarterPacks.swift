//
//  AppBskyGraphSearchStarterPacks.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-29.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Graph {

    /// An output model for the results of the starter pack search query.
    ///
    /// - Note: According to the AT Protocol specifications: "Find starter packs matching
    /// search criteria. Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.searchStarterPacks`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/searchStarterPacks.json
    public struct SearchStarterPacksOutput: Decodable, Sendable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of starter packs.
        public let starterPacks: [StarterPackViewBasicDefinition]
    }
}
