//
//  ChatBskyConvoSendMessage.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Conversation {

    /// A request body model for sending a message.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.sendMessage`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/sendMessage.json
    public struct SendMessageRequestBody: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        /// The message text itself.
        public let message: MessageInputDefinition

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
            case message
        }
    }
}
