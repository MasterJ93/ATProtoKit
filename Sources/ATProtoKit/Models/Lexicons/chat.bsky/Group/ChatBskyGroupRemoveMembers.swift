//
//  ChatBskyGroupRemoveMembers.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Group {

    /// A request body model for removing members from a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Removes members from a group. This
    /// deletes convo memberships, doesn't just set a status."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.removeMembers`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/removeMembers.json
    public struct RemoveMembersRequestBody: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        /// An array of decentralized identifiers (DIDs) of the members to remove.
        public let memberDIDs: [String]

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
            case memberDIDs = "members"
        }
    }

    /// An output model for removing members from a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Removes members from a group. This
    /// deletes convo memberships, doesn't just set a status."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.removeMembers`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/removeMembers.json
    public struct RemoveMembersOutput: Sendable, Codable {

        /// The group conversation the user account has successfully removed members from.
        public let conversation: ChatBskyLexicon.Conversation.ConversationViewDefinition

        enum CodingKeys: String, CodingKey {
            case conversation = "convo"
        }
    }
}
