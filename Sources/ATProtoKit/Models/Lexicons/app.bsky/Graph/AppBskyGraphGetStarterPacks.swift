//
//  AppBskyGraphGetStarterPacks.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-29.
//

import Foundation

extension AppBskyLexicon.Graph {

    /// An output model for getting an array of starter packs.
    ///
    /// - Note: According to the AT Protocol specifications: "Get views for a list of starter packs."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getStarterPacks`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getStarterPacks.json
    public struct GetStarterPacksOutput: Sendable, Codable {

        /// An array of starter pack records.
        public let starterPacks: [StarterPackViewBasicDefinition]
    }
}
