//
//  BskyActorSearchActors.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-23.
//

import Foundation

/// A data model definition for the output of searching for actors matching the search criteria.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.searchActors`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/searchActors.json
public struct ActorSearchActorsOutput: Codable {
    /// The mark used to indicate the starting point for the next set of results. Optional.
    public let cursor: String
    /// An array of actors.
    public let actors: [ActorProfileView]
}
