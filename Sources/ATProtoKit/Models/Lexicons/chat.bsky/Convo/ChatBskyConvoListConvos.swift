//
//  ChatBskyConvoListConvos.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Conversation {

    /// A definition model for listing various conversations.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.listConvos`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/listConvos.json
    public struct ListConversations: Sendable, Codable {

        /// The read state of conversation.
        public enum ReadState: String, Sendable, Codable {

            /// The conversation has been unread.
            case unread
        }

        /// The status of the conversation.
        public enum Status: String, Sendable, Codable {

            /// The conversation is waiting to be accepted.
            case request

            /// The conversation has been accepted.
            case accepted
        }
    }

    /// An output model for listing various conversations.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.listConvos`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/listConvos.json
    public struct ListConversationsOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of conversations.
        public let conversations: [ConversationViewDefinition]

        enum CodingKeys: String, CodingKey {
            case cursor
            case conversations = "convos"
        }
    }
}
