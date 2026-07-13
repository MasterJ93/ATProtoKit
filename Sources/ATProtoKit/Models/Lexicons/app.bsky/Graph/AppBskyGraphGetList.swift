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
        
        public init(cursor: String?, list: ListViewDefinition, items: [ListItemViewDefinition]) {
            self.cursor = cursor
            self.list = list
            self.items = items
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
            self.list = try container.decode(AppBskyLexicon.Graph.ListViewDefinition.self, forKey: .list)
            self.items = try container.decode([AppBskyLexicon.Graph.ListItemViewDefinition].self, forKey: .items)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(self.cursor, forKey: .cursor)
            try container.encode(self.list, forKey: .list)
            try container.encode(self.items, forKey: .items)
        }
        
        enum CodingKeys: CodingKey {
            case cursor
            case list
            case items
        }
    }
}
