//
//  AppBskyActorPutPreferences.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-17.
//

import Foundation

extension AppBskyLexicon.Actor {

    public struct PutPreferencesRequestBody: Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.putPreferences"

        /// A list of preferences by the user.
        public let preferences: [ATUnion.ActorPreferenceUnion]
        
        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case preferences
        }
    }
}
