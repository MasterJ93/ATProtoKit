//
//  ChatBskyGroupCreateGroup.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Group {

    /// A request body model for creating a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Creates a group convo, specifying the
    /// members to be added to it. Unlike getConvoForMembers, this isn't idempotent. It will create
    /// new groups even if the membership is identical to pre-existing groups. Will create 'request'
    /// membership for all members, except the owner who is 'accepted'."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.createGroup`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/createGroup.json
    public struct CreateGroupRequestBody: Sendable, Codable {

        /// An array of decentralized identifiers (DIDs) of the members to add.
        ///
        /// - Note: According to the AT Protocol specifications: "The members to add to the group.
        /// The owner is automatically added. Implementations may enforce a lower maximum than the
        /// 10,000-item schema limit; Bluesky currently supports up to 100 total members. If the
        /// owner is included in this list, the list may contain up to the implementation's total
        /// member limit. Otherwise, it may contain one fewer."
        ///
        /// - Important: Current maximum length is 10,000 items.
        public let memberDIDs: [String]

        /// The name of the group conversation.
        ///
        /// - Important: Current maximum length is 50 characters.
        public let name: String

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.truncatedEncode(self.memberDIDs, forKey: .memberDIDs, upToCharacterLength: 10_000)
            try container.truncatedEncode(self.name, forKey: .name, upToCharacterLength: 50)
        }

        enum CodingKeys: String, CodingKey {
            case memberDIDs = "members"
            case name
        }
    }

    /// An output model for creating a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Creates a group convo, specifying the
    /// members to be added to it. Unlike getConvoForMembers, this isn't idempotent. It will create
    /// new groups even if the membership is identical to pre-existing groups. Will create 'request'
    /// membership for all members, except the owner who is 'accepted'."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.createGroup`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/createGroup.json
    public struct CreateGroupOutput: Sendable, Codable {

        /// The group conversation the user account has successfully created.
        public let conversation: ChatBskyLexicon.Conversation.ConversationViewDefinition

        enum CodingKeys: String, CodingKey {
            case conversation = "convo"
        }
    }
}
