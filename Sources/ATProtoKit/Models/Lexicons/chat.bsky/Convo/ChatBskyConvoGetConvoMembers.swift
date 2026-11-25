//
//  ChatBskyConvoGetConvoMembers.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Conversation {

    /// An output model for getting the members of a conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Returns a paginated list of members
    /// from a conversation."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.getConvoMembers`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/convo/getConvoMembers.json
    public struct GetConversationMembersOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of members.
        public let members: [ChatBskyLexicon.Actor.ProfileViewBasicDefinition]
    }
}
