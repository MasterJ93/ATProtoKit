//
//  AppBskyGraphGetActorStarterPacks.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-29.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Graph {
    
    /// An output model for getting the user account's starter packs.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of starter packs created
    /// by the actor."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getActorStarterPacks`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getActorStarterPacks.json
    public struct GetActorStarterPacksOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of the user account's starter packs.
        public let starterPacks: [StarterPackViewBasicDefinition]
    }
}
