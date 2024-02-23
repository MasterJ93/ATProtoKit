//
//  BskyActorSearchActorsTypeahead.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-23.
//

import Foundation

/// The main data model definition for an actor search suggestion query.
///
/// - Note: According to the AT Protocol specifications: "Find actor suggestions for a prefix search term. Expected use is for auto-completion during text field entry. Does not require auth."
///
/// - SeeAlso: This is based on the [`app.bsky.actor.searchActors`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/searchActors.json
public struct ActorSearchActorsTypeahead: Codable {
    /// The string used against a list of actors.
    ///
    /// - Note: According to the AT Protocol specifications: "Search query prefix; not a full query string."
    public let query: String
    /// The number of items in the results. Optional. Defaults to 10 items. Can only be between 1 and 100 items.
    public let limit: Int = 10

    enum CodingKeys: String, CodingKey {
        case query = "q"
        case limit
    }
}

public struct ActorSearchActorsTypeaheadOutput: Codable {
    /// An array of actors.
    public let actors: [ActorProfileViewBasic]
}
