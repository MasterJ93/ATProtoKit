//
//  ChatBskyConvoUnlockConvo.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Conversation {

    /// A request body model for unlocking a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Unlocks a group convo so it is able
    /// to receive new content."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.unlockConvo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/convo/unlockConvo.json
    public struct UnlockConversationRequestBody: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
        }
    }

    /// An output model for unlocking a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Unlocks a group convo so it is able
    /// to receive new content."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.unlockConvo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/convo/unlockConvo.json
    public struct UnlockConversationOutput: Sendable, Codable {

        /// The conversation the user account has successfully unlocked.
        public let conversation: ConversationViewDefinition

        enum CodingKeys: String, CodingKey {
            case conversation = "convo"
        }
    }
}
