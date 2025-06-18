//
//  AppBskyActorGetSuggestions.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-17.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Actor {

    /// A data model for the output of the list of suggested users to follow.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of suggested actors.
    /// Expected use is discovery of accounts to follow during new account onboarding."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.getSuggestions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getSuggestions.json
    public struct GetSuggestionsOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of actors.
        public let actors: [ProfileViewDefinition]

        /// A Snowflake ID for recommendation events. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Snowflake for this
        /// recommendation, use when submitting recommendation events."
        public let recommendationID: Int?

        enum CodingKeys: String, CodingKey {
            case cursor
            case actors
            case recommendationID = "recId"
        }
    }
}
