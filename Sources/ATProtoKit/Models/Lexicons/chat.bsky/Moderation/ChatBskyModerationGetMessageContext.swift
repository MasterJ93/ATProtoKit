//
//  ChatBskyModerationGetMessageContext.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Moderation {

    /// The data model definition for the output of getting the message context.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.moderation.getMessageContext`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/moderation/getMessageContext.json
    public struct GetMessageContextOutput: Codable {

        /// An array of messages.
        public let messages: [ATUnion.MessageViewUnion]
    }
}
