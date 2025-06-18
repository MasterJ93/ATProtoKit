//
//  ChatBskyConvoDeleteMessageForSelf.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Conversation {

    /// A request body model for deleting a message only from the user account's end.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.deleteMessageForSelf`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/deleteMessageForSelf.json
    public struct DeleteMessageForSelfRequestBody: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        /// The ID of the message.
        public let messageID: String

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoID"
            case messageID = "messageId"
        }
    }
}
