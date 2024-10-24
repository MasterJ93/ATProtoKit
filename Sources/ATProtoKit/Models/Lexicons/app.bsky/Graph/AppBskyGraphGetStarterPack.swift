//
//  AppBskyGraphGetStarterPack.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-29.
//

import Foundation

extension AppBskyLexicon.Graph {

    /// An output model for getting a starter pack.
    ///
    /// - Note: According to the AT Protocol specifications: "Gets a view of a starter pack."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getStarterPack`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getStarterPack.json
    public struct GetStarterPackOutput: Sendable, Codable {

        /// A starter pack record.
        public let starterPack: [StarterPackViewDefinition]
    }
}
