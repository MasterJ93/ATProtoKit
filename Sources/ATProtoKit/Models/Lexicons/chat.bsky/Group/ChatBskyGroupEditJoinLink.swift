//
//  ChatBskyGroupEditJoinLink.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Group {

    /// A request body model for editing the join link of a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Edits the existing join link settings
    /// for the group convo."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.editJoinLink`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/editJoinLink.json
    public struct EditJoinLinkRequestBody: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        /// Indicates whether joining through the join link requires approval. Optional.
        public let isApprovalRequired: Bool?

        /// The rule for joining the group conversation. Optional.
        public let joinRule: JoinRuleDefinition?

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
            case isApprovalRequired = "requireApproval"
            case joinRule
        }
    }

    /// An output model for editing the join link of a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Edits the existing join link settings
    /// for the group convo."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.editJoinLink`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/editJoinLink.json
    public struct EditJoinLinkOutput: Sendable, Codable {

        /// The join link the user account has successfully edited.
        public let joinLink: JoinLinkViewDefinition
    }
}
