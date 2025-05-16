//
//  ChatBskyConvoAddReaction.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-16.
//

import Foundation

extension ChatBskyLexicon.Conversation {

    /// A request body model for adding an emoji in a message as a reaction.
    ///
    /// - Note: According to the AT Protocol specifications: "Adds an emoji reaction to a message.
    /// Requires authentication. It is idempotent, so multiple calls from the same user with the same emoji
    /// result in a single reaction."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.addReaction`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/addReaction.json
    public struct AddReactionRequestBody: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        /// The ID of the message.
        public let messageID: String

        /// The value of the reaction.
        public let value: String

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.conversationID, forKey: .conversationID)
            try container.encode(self.messageID, forKey: .messageID)
            try container.truncatedEncode(self.value, forKey: .value, upToCharacterLength: 64)
        }

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
            case messageID = "messageId"
            case value
        }
    }

    /// An output model for adding an emoji in a message as a reaction.
    ///
    /// - Note: According to the AT Protocol specifications: "Adds an emoji reaction to a message.
    /// Requires authentication. It is idempotent, so multiple calls from the same user with the same emoji
    /// result in a single reaction."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.addReaction`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/addReaction.json
    public struct AddReactionOutput: Sendable, Codable {

        /// The message the reaction is attached to.
        public let message: ChatBskyLexicon.Conversation.MessageViewDefinition
    }
}
