//
//  ChatBskyConvoGetLog.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Conversation {

    /// An output model for getting logs for messages.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.getLog`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/getLog.json
    public struct GetLogOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of logs.
        public let logs: [LogsUnion]

        // Unions
        /// A reference containing the list of message logs.
        public enum LogsUnion: Sendable, Codable {

            /// A log entry for beginning the coversation.
            case logBeginConversation(ChatBskyLexicon.Conversation.LogBeginConversationDefinition)

            /// A log entry for accepting a conversation.
            case logAcceptConversation(ChatBskyLexicon.Conversation.LogAcceptConversationDefinition)

            /// A log entry for leaving the conversation.
            case logLeaveConversation(ChatBskyLexicon.Conversation.LogLeaveConversationDefinition)

            /// A log entry for creating a message.
            case logCreateMessage(ChatBskyLexicon.Conversation.LogCreateMessageDefinition)

            /// A log entry for deleting a message.
            case logDeleteMessage(ChatBskyLexicon.Conversation.LogDeleteMessageDefinition)

            public init(from decoder: any Decoder) throws {
                let container = try decoder.singleValueContainer()

                if let value = try? container.decode(ChatBskyLexicon.Conversation.LogBeginConversationDefinition.self) {
                    self = .logBeginConversation(value)
                } else if let value = try? container.decode(ChatBskyLexicon.Conversation.LogAcceptConversationDefinition.self) {
                    self = .logAcceptConversation(value)
                } else if let value = try? container.decode(ChatBskyLexicon.Conversation.LogLeaveConversationDefinition.self) {
                    self = .logLeaveConversation(value)
                } else if let value = try? container.decode(ChatBskyLexicon.Conversation.LogCreateMessageDefinition.self) {
                    self = .logCreateMessage(value)
                } else if let value = try? container.decode(ChatBskyLexicon.Conversation.LogDeleteMessageDefinition.self) {
                    self = .logDeleteMessage(value)
                } else {
                    throw DecodingError.typeMismatch(
                        LogsUnion.self, DecodingError.Context(
                            codingPath: decoder.codingPath, debugDescription: "Unknown LogsUnion type"))
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .logBeginConversation(let logBeginConversation):
                        try container.encode(logBeginConversation)
                    case .logAcceptConversation(let logAcceptConversation):
                        try container.encode(logAcceptConversation)
                    case .logLeaveConversation(let logLeaveConversation):
                        try container.encode(logLeaveConversation)
                    case .logCreateMessage(let logCreateMessage):
                        try container.encode(logCreateMessage)
                    case .logDeleteMessage(let logDeleteMessage):
                        try container.encode(logDeleteMessage)
                }
            }
        }
    }
}
