//
//  ChatBskyConvoListConvo.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Conversation {

    /// The data model definition for the output of listing a conversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.listConvos`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/listConvos.json
    public struct ListConversationOutput: Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String

        /// An array of conversations.
        public let conversations: [ConversationView]

        enum CodingKeys: String, CodingKey {
            case cursor
            case conversations = "convos"
        }
    }
}
