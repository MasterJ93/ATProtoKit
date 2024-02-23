//
//  BskyActorPutPreferences.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-22.
//

import Foundation

/// The main data model definition for editing user preferences.
///
/// - Note: According to the AT Protocol specifications: "Set the private preferences attached to the account."
///
/// - SeeAlso: This is based on the [`app.bsky.actor.putPreferences`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/putPreferences.json
public struct ActorPutPreferences: Codable {
    public let type: String = "app.bsky.actor.putPreferences"
    /// A list of preferences by the user.
    public let preferences: [ActorPreferenceUnion]

    public init(preferences: [ActorPreferenceUnion]) {
        self.preferences = preferences
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case preferences
    }
}
