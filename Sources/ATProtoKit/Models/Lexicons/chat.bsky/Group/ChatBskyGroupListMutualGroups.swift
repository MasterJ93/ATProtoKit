//
//  ChatBskyGroupListMutualGroups.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Group {

    /// An output model for listing the mutual group conversations.
    ///
    /// - Note: According to the AT Protocol specifications: "Returns a page of group conversations
    /// that both the requester and the specified actor are members of."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.listMutualGroups`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/listMutualGroups.json
    public struct ListMutualGroupsOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of group conversations.
        public let conversations: [ChatBskyLexicon.Conversation.ConversationViewDefinition]

        enum CodingKeys: String, CodingKey {
            case cursor
            case conversations = "convos"
        }
    }
}
