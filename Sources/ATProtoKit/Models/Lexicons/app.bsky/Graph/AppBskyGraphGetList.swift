//
//  AppBskyGraphGetList.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Graph {

    /// An output model for grabbing the list view.
    ///
    /// - Note: According to the AT Protocol specifications: "Gets a 'view' (with additional context)
    /// of a specified list."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getList`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getList.json
    public struct GetListOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// The metadata of the list.
        public let list: ListViewDefinition

        /// An array of list items.
        public let items: [ListItemViewDefinition]
    }
}
