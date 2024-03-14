//
//  BskyGraphGetListMutes.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-10.
//

import Foundation

/// The main data model definition for the output of grabbing the moderator list that the user account is currently muting.
///
/// - Note: According to the AT Protocol specifications: "Enumerates mod lists that the requesting account (actor) currently has muted. Requires auth."
///
/// - SeeAlso: This is based on the [`app.bsky.graph.getListMutes`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getListMutes.json
public struct GraphGetListMutesOutput: Codable {
    /// The mark used to indicate the starting point for the next set of results. Optional.
    public let cursor: String?
    /// An array of lists the user account is muting.
    public let lists: [GraphListView]
}
