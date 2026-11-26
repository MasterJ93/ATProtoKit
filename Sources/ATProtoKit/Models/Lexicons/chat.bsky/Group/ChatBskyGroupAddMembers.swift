//
//  ChatBskyGroupAddMembers.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Group {

    /// A request body model for adding members to a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Adds members to a group. The members
    /// are added in 'request' status, so they have to accept it. This creates convo memberships."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.addMembers`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/addMembers.json
    public struct AddMembersRequestBody: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        /// An array of decentralized identifiers (DIDs) of the members to add.
        public let memberDIDs: [String]

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
            case memberDIDs = "members"
        }
    }

    /// An output model for adding members to a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Adds members to a group. The members
    /// are added in 'request' status, so they have to accept it. This creates convo memberships."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.addMembers`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/addMembers.json
    public struct AddMembersOutput: Sendable, Codable {

        /// The group conversation the user account has successfully added members to.
        public let conversation: ChatBskyLexicon.Conversation.ConversationViewDefinition

        /// An array of members that were added. Optional.
        public let addedMembers: [ChatBskyLexicon.Actor.ProfileViewBasicDefinition]?

        enum CodingKeys: String, CodingKey {
            case conversation = "convo"
            case addedMembers
        }
    }
}
