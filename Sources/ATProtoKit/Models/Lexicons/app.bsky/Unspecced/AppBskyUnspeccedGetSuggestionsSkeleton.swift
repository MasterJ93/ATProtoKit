//
//  AppBskyUnspeccedGetSuggestionsSkeleton.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Unspecced {

    /// An output model for getting a skeleton of suggestion of actors.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a skeleton of suggested actors.
    /// Intended to be called and then hydrated through app.bsky.actor.getSuggestions."
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may change
    /// or be removed at any time. Use at your own risk.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getSuggestionsSkeleton`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getSuggestionsSkeleton.json
    public struct GetSuggestionsSkeletonOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of actors.
        public let actors: [SkeletonSearchActorDefinition]

        /// The decentralized identifier (DID) of the user account related to the suggestions.
        /// Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "DID of the account these
        /// suggestions are relative to. If this is returned undefined, suggestions are based on
        /// the viewer."
        public let relativeToDID: String?

        /// A Snowflake ID for recommendation events. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Snowflake for this
        /// recommendation, use when submitting recommendation events."
        public let recommendationID: Int?

        enum CodingKeys: String, CodingKey {
            case cursor
            case actors
            case relativeToDID = "relativeToDid"
            case recommendationID = "recId"
        }
    }
}
