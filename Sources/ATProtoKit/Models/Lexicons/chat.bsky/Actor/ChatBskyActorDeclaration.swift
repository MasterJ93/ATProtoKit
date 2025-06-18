//
//  ChatBskyActorDeclaration.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Actor {

    /// A record model for a Bluesky chat account.
    ///
    /// - Note: According to the AT Protocol specifications: "A declaration of a Bluesky
    /// chat account."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.actor.declaration`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/actor/declaration.json
    public struct DeclarationRecord: ATRecordProtocol, Sendable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "chat.bsky.actor.declaration"

        /// Establishes a rule for who can message the user account.
        public let allowIncoming: AllIncoming

        public init(allowIncoming: AllIncoming) {
            self.allowIncoming = allowIncoming
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.allowIncoming = try container.decode(ChatBskyLexicon.Actor.DeclarationRecord.AllIncoming.self, forKey: .allowIncoming)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.allowIncoming, forKey: .allowIncoming)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case allowIncoming
        }

        // Enums
        /// A rule that states who can message the user account.
        public enum AllIncoming: Sendable, Codable {

            /// Indicates that anyone can message the user account.
            case all

            /// Indicates that no one can message the user account.
            case none

            /// Indicates that only people who the user account follows can message
            /// the user account.
            case following
        }
    }
}
