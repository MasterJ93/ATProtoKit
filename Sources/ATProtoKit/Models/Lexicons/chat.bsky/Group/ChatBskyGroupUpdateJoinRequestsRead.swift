//
//  ChatBskyGroupUpdateJoinRequestsRead.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Group {

    /// A request body model for marking all requests to join a group conversation as read.
    ///
    /// - Note: According to the AT Protocol specifications: "Marks all join requests as read for
    /// the group owner."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.updateJoinRequestsRead`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/updateJoinRequestsRead.json
    public struct UpdateJoinRequestsReadRequestBody: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
        }
    }
}
