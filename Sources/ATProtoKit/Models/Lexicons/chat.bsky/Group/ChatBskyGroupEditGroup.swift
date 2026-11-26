//
//  ChatBskyGroupEditGroup.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Group {

    /// A request body model for editing a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Edits group settings."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.editGroup`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/editGroup.json
    public struct EditGroupRequestBody: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        /// The name of the group conversation.
        ///
        /// - Important: Current maximum length is 50 characters.
        public let name: String

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.conversationID, forKey: .conversationID)
            try container.truncatedEncode(self.name, forKey: .name, upToCharacterLength: 50)
        }

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
            case name
        }
    }

    /// An output model for editing a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Edits group settings."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.editGroup`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/editGroup.json
    public struct EditGroupOutput: Sendable, Codable {

        /// The group conversation the user account has successfully edited.
        public let conversation: ChatBskyLexicon.Conversation.ConversationViewDefinition

        enum CodingKeys: String, CodingKey {
            case conversation = "convo"
        }
    }
}
