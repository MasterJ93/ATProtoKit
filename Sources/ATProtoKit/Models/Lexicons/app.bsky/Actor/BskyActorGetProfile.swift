//
//  BskyActorGetProfile.swift.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-18.
//

import Foundation

/// The main data model definition for getting a detailed profile view for the user.
///
/// - Note: According to the AT Protocol specifications: "Get detailed profile view of an actor. Does not require auth, but contains relevant metadata with auth."
///
/// - SeeAlso: This is based on the [`app.bsky.actor.getProfile`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getProfile.json
public struct ActorGetProfileQuery: Codable {
    /// The handle or decentralized identifier (DID) of the user.
    ///
    /// - Note: According to the AT Protocol specifications: "Handle or DID of account to fetch profile of."
    public let actorDID: String
}

/// A data model definition for the output for a detailed profile view for the user.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.getProfile`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getProfile.json
public struct ActorGetProfileOutput: Codable {
    /// A detailed profile view of the user.
    public let actorProfileView: ActorProfileViewDetailed
}
