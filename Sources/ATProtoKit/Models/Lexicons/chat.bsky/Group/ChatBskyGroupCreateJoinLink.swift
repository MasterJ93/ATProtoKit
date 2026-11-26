//
//  ChatBskyGroupCreateJoinLink.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Group {

    /// A request body model for creating a join link for a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Creates a join link for the group
    /// convo."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.createJoinLink`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/createJoinLink.json
    public struct CreateJoinLinkRequestBody: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        /// Indicates whether joining through the join link requires approval. Optional. Defaults
        /// to `false`.
        public let isApprovalRequired: Bool?

        /// The rule for joining the group conversation.
        public let joinRule: JoinRuleDefinition

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
            case isApprovalRequired = "requireApproval"
            case joinRule
        }
    }

    /// An output model for creating a join link for a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Creates a join link for the group
    /// convo."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.createJoinLink`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/createJoinLink.json
    public struct CreateJoinLinkOutput: Sendable, Codable {

        /// The join link the user account has successfully created.
        public let joinLink: JoinLinkViewDefinition
    }
}
