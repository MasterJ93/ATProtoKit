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
    public struct MuteConversationRequestBody: Codable {

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
    public struct MuteConversationOutput: Codable {

        /// The conversation itself.
        public let conversation: [ConversationViewDefinition]

        enum CodingKeys: String, CodingKey {
            case conversation = "convo"
        }
    }
}
