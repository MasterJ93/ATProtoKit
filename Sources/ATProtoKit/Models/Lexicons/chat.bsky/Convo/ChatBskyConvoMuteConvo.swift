//
//  ChatBskyConvoMuteConvo.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Conversation {

    /// A request body model for muting a conversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.muteConvo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/muteConvo.json
    public struct MuteConversationRequestBody: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
        }
    }

    /// An output model for muting a conversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.muteConvo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/muteConvo.json
    public struct MuteConversationOutput: Sendable, Codable {

        /// The conversation the user account has successfully muted.
        public let conversation: ConversationViewDefinition

        enum CodingKeys: String, CodingKey {
            case conversation = "convo"
        }
    }
}
