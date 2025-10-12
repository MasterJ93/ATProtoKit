//
//  AppBskyGraphMuteActor.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Graph {

    /// A request body model formuting a user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Creates a mute relationship for the
    /// specified account. Mutes are private in Bluesky. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.muteActor`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/muteActor.json
    public struct MuteActorRequestBody: Sendable, Codable {

        /// The AT Identifier or handle of a user account.
        public let actor: String

        public init(actor: String) {
            self.actor = actor
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.actor = try container.decode(String.self, forKey: CodingKeys.actor)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.actor, forKey: CodingKeys.actor)
        }
        
        enum CodingKeys: CodingKey {
            case actor
        }
    }
}
