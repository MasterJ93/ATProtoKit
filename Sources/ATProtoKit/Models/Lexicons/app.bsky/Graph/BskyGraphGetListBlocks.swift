//
//  BskyGraphGetListBlocks.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-10.
//

import Foundation

/// The main data model definition for the output of getting the moderator lists that the user account is blocking.
///
/// - Note: According to the AT Protocol specifications: "Get mod lists that the requesting account (actor) is blocking. Requires auth."
///
/// - SeeAlso: This is based on the [`app.bsky.graph.getListBlocks`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getListBlocks.json
public struct 
