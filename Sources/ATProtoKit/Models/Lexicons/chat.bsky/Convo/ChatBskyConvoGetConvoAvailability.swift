//
//  ChatBskyConvoGetConvoAvailability.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-21.
//

import Foundation

extension ChatBskyLexicon.Conversation {

    /// An output model for checking if the requester and other members can chat.
    ///
    /// - Note: According to the AT Protocol specifications: "Get whether the requester and the
    /// other members can chat. If an existing convo is found for these members, it is returned."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.getConvoAvailability`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/getConvoAvailability.json
    public struct GetConversationAvailabilityOutput: Sendable, Codable {

        /// Indicates whether the requester can outher members can chat.
        public let canChat: Bool

        /// The conversation itself. Optional.
        public let conversation: ChatBskyLexicon.Conversation.ConversationViewDefinition?

        enum CodingKeys: String, CodingKey {
            case canChat
            case conversation = "convo"
        }
    }
}
