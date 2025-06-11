//
//  AppBskyActorPutPreferences.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-17.
//

import Foundation

extension AppBskyLexicon.Actor {

    /// A request body model for editing preferences in a user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Set the private preferences attached
    /// to the account."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.putPreferences`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/putPreferences.json
    public struct PutPreferencesRequestBody: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.putPreferences"

        /// A list of preferences by the user.
        public let preferences: [AppBskyLexicon.Actor.PreferenceUnion]

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case preferences
        }
    }
}
