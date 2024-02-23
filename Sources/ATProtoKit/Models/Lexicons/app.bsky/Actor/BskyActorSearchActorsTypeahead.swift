//
//  BskyActorSearchActorsTypeahead.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-23.
//

import Foundation

/// A data model definition for the output of searching for actors matching the prefixed search criteria.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.searchActorsTypeahead`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/searchActorsTypeahead.json

public struct ActorSearchActorsTypeaheadOutput: Codable {
    /// An array of actors.
    public let actors: [ActorProfileViewBasic]
}
