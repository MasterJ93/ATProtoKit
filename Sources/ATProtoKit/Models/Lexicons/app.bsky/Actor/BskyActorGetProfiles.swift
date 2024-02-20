//
//  BskyActorGetProfiles.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-19.
//

import Foundation

/// The main data model definition for getting a detailed profile views for multiple users.
///
/// - Note: According to the AT Protocol specifications: "Get detailed profile views of multiple actors."
///
/// - SeeAlso: This is based on the [`app.bsky.actor.getProfiles`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getProfiles.json
public struct ActorGetProfilesQuery: Codable {
    /// The handles or decentralized identifiers (DID) of the users.
    ///
    /// - Important: Current maximum length is 25 handles and/or DIDs. This library will automatically truncate the `Array` to the maximum length if it does go over the limit.
    public let actors: [String]

    public init(actors: [String]) {
        self.actors = actors
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.actors = try container.decode([String].self, forKey: .actors)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try truncatedEncode(self.actors, withContainer: &container, forKey: .actors, upToLength: 25)
    }

    enum CodingKeys: CodingKey {
        case actors
    }
}

/// A data model definition for the output of detailed profile views for multiple users.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.getProfiles`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getProfiles.json
public struct ActorGetProfilesOutput: Codable {
    /// An array of detailed profile views for several users.
    public let profiles: [ActorProfileViewDetailed]
}
