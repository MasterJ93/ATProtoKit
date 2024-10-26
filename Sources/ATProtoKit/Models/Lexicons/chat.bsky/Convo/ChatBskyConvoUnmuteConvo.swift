//
//  ChatBskyConvoUnmuteConvo.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Conversation {

    /// A request body model for unmuting a conversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.unmuteConvo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/unmuteConvo.json
    public struct UnMuteConversationRequestBody: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
        }
    }

    /// An output model for unmuting a conversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.unmuteConvo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/unmuteConvo.json
    public struct UnmuteConversationOutput: Sendable, Codable {

        /// The conversation itself.
        public let conversationView: ConversationViewDefinition

        enum CodingKeys: String, CodingKey {
            case conversationView = "convo"
        }
    }
}
