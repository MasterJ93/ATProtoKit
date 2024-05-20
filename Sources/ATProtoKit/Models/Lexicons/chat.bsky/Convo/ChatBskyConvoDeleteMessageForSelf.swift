//
//  ChatBskyConvoDeleteMessageForSelf.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Conversation {

    /// The request body data model definition for a message reference.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.deleteMessageForSelf`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/deleteMessageForSelf.json
    public struct DeleteMessageForSelfRequestBody: Codable {

        /// The ID of the conversation.
        public let conversationID: String

        /// The ID of the message.
        public let messageID: DeleteMessageViewDefinition

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoID"
            case messageID = "messageId"
        }
    }
}
