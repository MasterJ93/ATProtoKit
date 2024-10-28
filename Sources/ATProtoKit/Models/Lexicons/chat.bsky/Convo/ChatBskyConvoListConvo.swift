//
//  ChatBskyConvoListConvo.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Conversation {

    /// An output model for listing various conversations.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.listConvos`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/listConvos.json
    public struct ListConversationsOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String

        /// An array of conversations.
        public let conversations: [ConversationViewDefinition]

        enum CodingKeys: String, CodingKey {
            case cursor
            case conversations = "convos"
        }
    }
}
