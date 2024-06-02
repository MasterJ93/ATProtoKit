//
//  AppBskyActorGetSuggestions.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-17.
//

import Foundation

extension AppBskyLexicon.Actor {

    /// A data model for the output of the list of suggested users to follow.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of suggested actors.
    /// Expected use is discovery of accounts to follow during new account onboarding."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.getSuggestions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getSuggestions.json
    public struct GetSuggestionsOutput: Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of actors.
        public let actors: [ProfileViewDefinition]
    }
}
