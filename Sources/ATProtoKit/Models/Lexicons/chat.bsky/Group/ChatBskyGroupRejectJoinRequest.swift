//
//  ChatBskyGroupRejectJoinRequest.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Group {

    /// A request body model for rejecting a request to join a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Rejects a request to join a group (via
    /// join link) the user owns. Action taken by the group owner."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.rejectJoinRequest`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/rejectJoinRequest.json
    public struct RejectJoinRequestRequestBody: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        /// The decentralized identifier (DID) of the user account that requested to join.
        public let memberDID: String

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
            case memberDID = "member"
        }
    }
}
