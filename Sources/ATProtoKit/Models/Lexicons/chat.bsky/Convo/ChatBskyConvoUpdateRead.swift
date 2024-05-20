//
//  ChatBskyConvoUpdateRead.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Conversation {

    /// The request body data model definition for updating the conversation to mark it as read.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.updateRead`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/updateRead.json
    public struct UpdateReadRequestBody: Codable {

        /// The ID of the conversation to be marked as read.
        public let conversationID: String

        /// The ID of the message.
        public let messageID: String

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
            case messageID = "messageId"
        }
    }

    /// The main data model definition for the output of updating the conversation to mark it as read.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.updateRead`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/updateRead.json
    public struct UpdateReadOutput: Codable {

        /// The conversation itself.
        public let conversationView: ConversationViewDefinition
    }
}
