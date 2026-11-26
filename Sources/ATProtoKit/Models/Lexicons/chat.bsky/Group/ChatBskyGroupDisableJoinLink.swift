//
//  ChatBskyGroupDisableJoinLink.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Group {

    /// A request body model for disabling the join link of a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Disables the active join link for the
    /// group convo."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.disableJoinLink`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/disableJoinLink.json
    public struct DisableJoinLinkRequestBody: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
        }
    }

    /// An output model for disabling the join link of a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Disables the active join link for the
    /// group convo."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.disableJoinLink`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/disableJoinLink.json
    public struct DisableJoinLinkOutput: Sendable, Codable {

        /// The join link the user account has successfully disabled.
        public let joinLink: JoinLinkViewDefinition
    }
}
