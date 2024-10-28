//
//  AppBskyActorGetProfile.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-17.
//

import Foundation

extension AppBskyLexicon.Actor {

    /// A data model definition for the output for a detailed profile view for the user.
    ///
    /// - Note: According to the AT Protocol specifications: "Get detailed profile view of
    /// an actor. Does not require auth, but contains relevant metadata with auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.getProfile`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getProfile.json
    public struct GetProfileOutput: Sendable, Codable {

        /// A detailed profile view of the user.
        public let actorProfileView: ProfileViewDetailedDefinition
    }
}
