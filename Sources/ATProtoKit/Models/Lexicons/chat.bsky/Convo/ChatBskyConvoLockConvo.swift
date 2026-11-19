//
//  ChatBskyConvoLockConvo.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Conversation {

    /// A request body model for locking a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Locks a group convo so no more
    /// content (messages, reactions) can be added to it."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.lockConvo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/convo/lockConvo.json
    public struct LockConversationRequestBody: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
        }
    }

    /// An output model for locking a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Locks a group convo so no more
    /// content (messages, reactions) can be added to it."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.lockConvo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/convo/lockConvo.json
    public struct LockConversationOutput: Sendable, Codable {

        /// The conversation the user account has successfully locked.
        public let conversation: ConversationViewDefinition

        enum CodingKeys: String, CodingKey {
            case conversation = "convo"
        }
    }
}
