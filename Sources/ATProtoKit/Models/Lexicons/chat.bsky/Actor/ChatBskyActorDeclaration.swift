//
//  ChatBskyActorDeclaration.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Actor {

    /// A record model for a Bluesky chat account.
    ///
    /// - Note: According to the AT Protocol specifications: "A declaration of a Bluesky
    /// chat account."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.actor.declaration`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/actor/declaration.json
    public struct DeclarationRecord: ATRecordProtocol {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public private(set) static var type: String = "chat.bsky.actor.declaration"

        /// Establishes rule for who can message the user account.
        public let allowIncoming: AllIncoming

        enum CodingKeys: String, CodingKey {
            case allowIncoming
        }

        // Enums
        /// A rule that states who can message the user account.
        public enum AllIncoming: Codable {

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
