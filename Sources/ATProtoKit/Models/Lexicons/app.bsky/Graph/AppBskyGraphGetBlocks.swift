//
//  AppBskyGraphGetBlocks.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Graph {

    /// An output model for getting all of the users that have been blocked by the user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates which accounts the
    /// requesting account is currently blocking. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getBlocks`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getBlocks.json
    public struct GetBlocksOutput: Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of profiles that have been blocked by the user account.
        public let blocks: [AppBskyLexicon.Actor.ProfileViewDefinition]
    }
}
