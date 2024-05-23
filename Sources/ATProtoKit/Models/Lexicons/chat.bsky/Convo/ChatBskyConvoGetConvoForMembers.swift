//
//  ChatBskyConvoGetConvoForMembers.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Conversation {

    /// An output model for getting a conversation for members.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.getConvoForMembers`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/getConvoForMembers.json
    public struct GetConversationForMembersOutput: Codable {

        /// The conversation view.
        public let conversation: ConversationViewDefinition

        enum CodingKeys: String, CodingKey {
            case conversation = "convo"
        }
    }
}
