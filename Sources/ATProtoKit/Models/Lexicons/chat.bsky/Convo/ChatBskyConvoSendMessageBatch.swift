//
//  ChatBskyConvoSendMessageBatch.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Conversation {

    /// The main data model for sending a message batch.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.sendMessageBatch`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/sendMessageBatch.json
    public struct SendMessageBatch: Codable {

        /// A message batch object.
        ///
        /// - SeeAlso: This is based on the [`chat.bsky.convo.sendMessageBatch`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/sendMessageBatch.json
        public struct MessageBatchItem: Codable {

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

    /// A request body model for sending a message batch.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.sendMessageBatch`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/sendMessageBatch.json
    public struct SendMessageBatchRequestBody: Codable {

        /// An array of messages.
        public let items: [SendMessageBatch.MessageBatchItem]

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try truncatedEncode(self.items, withContainer: &container, forKey: .items, upToLength: 100)
        }
    }

    /// An output model for sending a message batch.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.sendMessageBatch`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/sendMessageBatch.json
    public struct SendMessageBatchOutput: Codable {

        /// An array of message views.
        public let items: [MessageViewDefinition]
    }
}
