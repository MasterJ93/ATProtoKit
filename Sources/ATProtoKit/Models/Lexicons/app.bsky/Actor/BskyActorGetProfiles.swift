//
//  BskyActorGetProfiles.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-19.
//

import Foundation

/// A data model definition for the output of detailed profile views for multiple users.
///
/// - Note: According to the AT Protocol specifications: "Get detailed profile views of
/// multiple actors."
///
/// - SeeAlso: This is based on the [`app.bsky.actor.getProfiles`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getProfiles.json
public struct ActorGetProfilesOutput: Codable {
    /// An array of detailed profile views for several users.
    public let profiles: [ActorProfileViewDetailed]
}
