//
//  ChatBskyConvoLeaveConvo.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Conversation {
    
    /// A request body model for leaving a conversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.leaveConvo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/leaveConvo.json
    public struct LeaveConversationRequestBody: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
        }
    }

    /// An output model for leaving a conversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.leaveConvo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/leaveConvo.json
    public struct LeaveConversationOutput: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        /// The revision of the conversation.
        public let revision: String

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
            case revision = "rev"
        }
    }
}
