//
//  BskyActorGetPreferences.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-18.
//

import Foundation

// MARK: -
/// A data model definition for the output of getting preferences.
///
/// - Note: According to the AT Protocol specifications: "Get private preferences attached to the current account. Expected use is synchronization between multiple devices, and import/export during
/// account migration. Requires auth."
/// - SeeAlso: This is based on the [`app.bsky.actor.getPreferences`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getPreferences.json
public struct ActorGetPreferencesOutput: Codable {
    /// The list of preferences in the user's account.
    public let preference: ActorPreferences
}
