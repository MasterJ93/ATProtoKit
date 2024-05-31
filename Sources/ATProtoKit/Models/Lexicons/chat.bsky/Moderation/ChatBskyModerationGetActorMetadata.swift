//
//  ChatBskyModerationGetActorMetadata.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Moderation {

    /// The main data model for getting the user account's metadata.
    public struct GetActorMetadata: Codable {

        /// The metadata given to the moderator.
        public struct Metadata: Codable {

            /// The number of messages sent from the user account.
            public let messagesSent: Int

            /// The number of messages the user account received.
            public let messagesReceived: Int

            /// The number of conversations the user account participates in.
            public let conversations: Int

            /// The number of conversations the user account had started.
            public let conversationsStarted: Int

            enum CodingKeys: String, CodingKey {
                case messagesSent
                case messagesReceived
                case conversations = "convos"
                case conversationsStarted = "convosStarted"
            }
        }
    }

    /// An output model for getting the user account's metadata.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.moderation.getActorMetadata`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/moderation/getActorMetadata.json
    public struct GetActorMetadataOutput: Codable {

        /// The metadata that reflects the past day.
        public let dayMetadata: GetActorMetadata.Metadata

        /// The metadata that reflects the past month.
        public let monthMetadata: GetActorMetadata.Metadata

        /// The metadata that reflects the entire lifetime of the user account.
        public let allMetadata: GetActorMetadata.Metadata

        enum CodingKeys: String, CodingKey {
            case dayMetadata = "day"
            case monthMetadata = "month"
            case allMetadata = "all"
        }
    }
}
