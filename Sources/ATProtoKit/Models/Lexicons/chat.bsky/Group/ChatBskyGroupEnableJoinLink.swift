//
//  ChatBskyGroupEnableJoinLink.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Group {

    /// A request body model for enabling the join link of a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Re-enables a previously disabled join
    /// link for the group convo."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.enableJoinLink`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/enableJoinLink.json
    public struct EnableJoinLinkRequestBody: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
        }
    }

    /// An output model for enabling the join link of a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Re-enables a previously disabled join
    /// link for the group convo."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.enableJoinLink`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/enableJoinLink.json
    public struct EnableJoinLinkOutput: Sendable, Codable {

        /// The join link the user account has successfully enabled.
        public let joinLink: JoinLinkViewDefinition
    }
}
