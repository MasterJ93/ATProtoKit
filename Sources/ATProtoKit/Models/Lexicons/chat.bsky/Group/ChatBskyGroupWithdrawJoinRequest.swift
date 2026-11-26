//
//  ChatBskyGroupWithdrawJoinRequest.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Group {

    /// A request body model for withdrawing a request to join a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Withdraws a pending request to join a
    /// group. Action taken by the prospective member who originally requested to join."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.withdrawJoinRequest`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/withdrawJoinRequest.json
    public struct WithdrawJoinRequestRequestBody: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
        }
    }
}
