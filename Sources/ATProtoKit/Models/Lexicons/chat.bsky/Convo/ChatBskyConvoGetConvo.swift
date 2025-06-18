//
//  ChatBskyConvoGetConvo.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Conversation {

    /// An output model for a message reference.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.getConvo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/getConvo.json
    public struct GetConversationOutput: Sendable, Codable {

        /// The conversation itself.
        public let conversation: ConversationViewDefinition

        enum CodingKeys: String, CodingKey {
            case conversation = "convo"
        }
    }
}
