//
//  ChatBskyConvoSendMessageBatch.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Conversation {

    /// The request body data model definition for sending a message batch.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.sendMessageBatch`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/sendMessageBatch.json
    public struct SendMessageBatchRequestBody: Codable {

        /// An array of messages.
        public let items: [MessageBatchItem]
    }

    /// The data model definition for the output of sending a message batch.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.sendMessageBatch`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/sendMessageBatch.json
    public struct SendMessageBatchOutput: Codable {

        /// An array of message views.
        public let items: [MessageView]
    }

    /// A message batch object.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.sendMessageBatch`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/sendMessageBatch.json
    public struct MessageBatchItem: Codable {

        /// The ID of the conversation.
        public let conversationID: String

        /// The message text itself.
        public let message: Message

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
            case message
        }
    }
}
