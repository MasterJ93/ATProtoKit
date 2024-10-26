//
//  AppBskyGraphUnmuteActor.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Graph {

    /// A request body model for unmuting a user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Unmutes the specified account.
    /// Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.unmuteActor`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/unmuteActor.json
    public struct UnmuteActorRequestBody: Sendable, Codable {

        /// The decentralized identifier (DID) or handle of a user account.
        public let actorDID: String

        enum CodingKeys: String, CodingKey {
            case actorDID = "actor"
        }
    }
}
