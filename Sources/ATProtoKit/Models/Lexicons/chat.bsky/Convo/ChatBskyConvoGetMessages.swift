//
//  ChatBskyConvoGetMessages.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Conversation {

    /// An output model for getting messages.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.getMessages`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/getMessages.json
    public struct GetMessagesOutput: Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of messages.
        public let messages: [ATUnion.GetMessagesOutputMessagesUnion]
    }
}
