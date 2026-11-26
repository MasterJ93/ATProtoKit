//
//  ChatBskyGroupListJoinRequests.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Group {

    /// An output model for listing the requests to join a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Lists a page of request to join a
    /// group (via join link) the user owns. Shows the data from the owner's point of view."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.listJoinRequests`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/listJoinRequests.json
    public struct ListJoinRequestsOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of join requests.
        public let requests: [JoinRequestViewDefinition]
    }
}
