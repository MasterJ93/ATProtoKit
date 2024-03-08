//
//  BskyGraphGetBlocks.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-08.
//

import Foundation

/// The main data model definition for the output of getting all of the users that have been blocked by the user account.
///
/// - Note: According to the AT Protocol specifications: "Enumerates which accounts the requesting account is currently blocking. Requires auth."
///
/// - SeeAlso: This is based on the [`app.bsky.graph.getBlocks`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getBlocks.json
public struct GraphGetBlocksOutput: Codable {
    /// The mark used to indicate the starting point for the next set of results. Optional.
    public let cursor: String?
    /// An array of profiles that have been blocked by the user account.
    public let blocks: [ActorProfileView]
}
