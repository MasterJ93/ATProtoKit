//
//  ChatBskyConvoAcceptConvo.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Conversation {

    /// A request body model for accepting a conversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.acceptConvo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/acceptConvo.json
    public struct AcceptConversationRequestBody: Sendable, Codable {

        /// The ID of the conversation.
        public let id: String

        enum CodingKeys: String, CodingKey {
            case id = "convoId"
        }
    }

    /// An output model for accepting a conversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.acceptConvo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/acceptConvo.json
    public struct AcceptConversationOutput: Sendable, Codable {

        /// The revision ID of the accepted conversation.
        ///
        /// If the ID is absent, then the conversation was already accepted.
        ///
        /// - Note: According to the AT Protocol specifications: "Rev when the convo was accepted. If not present, the convo was already accepted."
        public let revision: String

        enum CodingKeys: String, CodingKey {
            case revision = "rev"
        }
    }
}
