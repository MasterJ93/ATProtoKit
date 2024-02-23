//
//  BskyActorSearchActors.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-23.
//

import Foundation

/// The main data model definition for an actor search query.
///
/// - Note: According to the AT Protocol specifications: "Find actors (profiles) matching search criteria. Does not require auth."
///
/// - SeeAlso: This is based on the [`app.bsky.actor.searchActors`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/searchActors.json
public struct ActorSearchActors: Codable {
    /// The string used against a list of actors.
    ///
    /// - Note: According to the AT Protocol specifications: "Search query string. Syntax, phrase, boolean, and faceting is unspecified, but Lucene query syntax is recommended."
    public let query: String
    /// The number of items in the results. Optional. Defaults to 25 items.
    public let limit: Int = 25
    /// The mark used to indicate the starting point for the next set of results. Optional.
    public let cursor: String
    
    enum CodingKeys: String, CodingKey {
        case query = "q"
        case limit
        case cursor
    }
}

public struct ActorSearchActorsOutput: Codable {
    /// The mark used to indicate the starting point for the next set of results. Optional.
    public let cursor: String
    /// An array of actors.
    public let actors: [ActorProfileView]
}
