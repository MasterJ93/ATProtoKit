//
//  AppBskyGraphGetListBlocks.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Graph {

    /// An output model for getting the moderator lists that the user account is blocking.
    ///
    /// - Note: According to the AT Protocol specifications: "Get mod lists that the requesting
    /// account (actor) is blocking. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getListBlocks`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getListBlocks.json
    public struct GetListBlocksOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of lists that the user account is blocking.
        public let lists: [ListViewDefinition]
    }
}
