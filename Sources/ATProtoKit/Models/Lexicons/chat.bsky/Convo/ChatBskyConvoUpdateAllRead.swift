//
//  ChatBskyConvoUpdateAllRead.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-24.
//

import Foundation

extension ChatBskyLexicon.Conversation {

    /// A definition model for marking all conversations as read.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.updateAllRead`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/updateAllRead.json
    public struct UpdateAllRead: Sendable, Codable {

        /// The status of the conversation.
        public enum Status: String, Sendable, Codable {

            /// The conversation is waiting to be accepted.
            case request

            /// The conversation has been accepted.
            case accepted
        }
    }

    /// A request body model for marking all conversations as read.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.updateAllRead`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/updateAllRead.json
    public struct UpdateAllReadRequestBody: Sendable, Codable {

        /// The status of the conversation. Optional.
        public let status: UpdateAllRead.Status?
    }

    /// An output model for marking all conversations as read.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.updateAllRead`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/updateAllRead.json
    public struct UpdateAllReadOutput: Sendable, Codable {

        /// An updated count of conversations.
        ///
        /// - Note: According to the AT Protocol specifications: "The count of updated convos."
        public let updatedCount: Int
    }
}
