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
    /// specified account. If a mute already exists for the account, it is updated in place: the
    /// stored scope is replaced with the scope in this request. Mutes are private in Bluesky.
    /// Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.muteActor`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/graph/muteActor.json
    public struct MuteActorRequestBody: Sendable, Codable {

        /// The AT Identifier or handle of a user account.
        public let actor: String

        /// Determines whether only the user account's reposts are muted. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Restrict the mute to the account's
        /// reposts. When any 'only' scope is set, just the scoped content is muted; when none are set,
        /// the account is fully muted. Repeat calls replace the stored scope rather than adding to it."
        public let isOnlyReposts: Bool?

        /// Determines whether only the user account's quote posts are muted. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Restrict the mute to the account's
        /// quote posts. See onlyReposts."
        public let isOnlyQuotePosts: Bool?

        public init(actor: String, isOnlyReposts: Bool? = nil, isOnlyQuotePosts: Bool? = nil) {
            self.actor = actor
            self.isOnlyReposts = isOnlyReposts
            self.isOnlyQuotePosts = isOnlyQuotePosts
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.actor = try container.decode(String.self, forKey: CodingKeys.actor)
            self.isOnlyReposts = try container.decodeIfPresent(Bool.self, forKey: CodingKeys.isOnlyReposts)
            self.isOnlyQuotePosts = try container.decodeIfPresent(Bool.self, forKey: CodingKeys.isOnlyQuotePosts)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.actor, forKey: CodingKeys.actor)
            try container.encodeIfPresent(self.isOnlyReposts, forKey: CodingKeys.isOnlyReposts)
            try container.encodeIfPresent(self.isOnlyQuotePosts, forKey: CodingKeys.isOnlyQuotePosts)
        }

        enum CodingKeys: String, CodingKey {
            case actor
            case isOnlyReposts = "onlyReposts"
            case isOnlyQuotePosts = "onlyQuoteposts"
        }
    }
}
