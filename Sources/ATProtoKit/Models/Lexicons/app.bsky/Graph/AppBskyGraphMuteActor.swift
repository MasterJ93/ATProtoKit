//
//  AppBskyGraphMuteActor.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Graph {

    /// A request body model formuting a user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Creates a mute relationship for the
    /// specified account. Mutes are private in Bluesky. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.muteActor`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/muteActor.json
    public struct MuteActorRequestBody: Codable {

        /// The decentralized identifier (DID) or handle of a user account.
        public let actorDID: String

        enum CodingKeys: String, CodingKey {
            case actorDID = "actor"
        }
    }
}
