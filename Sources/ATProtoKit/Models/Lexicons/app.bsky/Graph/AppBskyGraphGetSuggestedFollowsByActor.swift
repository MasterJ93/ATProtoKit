//
//  AppBskyGraphGetSuggestedFollowsByActor.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Graph {

    /// A output model for getting the list of user accounts that requesting user account is
    /// suggested to follow.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates follows similar to a given
    /// account (actor). Expected use is to recommend additional accounts immediately after
    /// following one account."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getSuggestedFollowsByActor`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getSuggestedFollowsByActor.json
    public struct GetSuggestedFollowsByActorOutput: Sendable, Codable {

        /// An array of user accounts the requesting user account is suggested to follow.
        public let suggestions: [AppBskyLexicon.Actor.ProfileViewDefinition]

        /// Indicates whether the results are generic. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "If true, response has fallen-back
        /// to generic results, and is not scoped using relativeToDid"
        public let isFallback: Bool? = false

        enum CodingKeys: CodingKey {
            case suggestions
            case isFallback
        }
    }
}
