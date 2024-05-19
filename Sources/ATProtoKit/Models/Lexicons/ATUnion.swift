//
//  ATUnion.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

/// An object that lists all of the union types for each of the lexicons.
public struct ATUnion {

    /// A reference containing the list of message embeds.
    public enum MessageEmbedUnion: Codable {
        case record(AppBskyLexicon.Embed.RecordDefinition)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Embed.RecordDefinition.self) {
                self = .record(value)
            } else {
                throw DecodingError.typeMismatch(
                    MessageEmbedUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown MessageEmbedUnion type"))
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .record(let record):
                    try container.encode(record)
            }
        }
    }

    /// A reference containing the list of messages.
    public enum MessageViewUnion: Codable {
        case messageView(ChatBskyLexicon.Conversation.MessageView)
        case deletedMessageView(ChatBskyLexicon.Conversation.DeleteMessageView)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ChatBskyLexicon.Conversation.MessageView.self) {
                self = .messageView(value)
            } else if let value = try? container.decode(ChatBskyLexicon.Conversation.DeleteMessageView.self) {
                self = .deletedMessageView(value)
            } else {
                throw DecodingError.typeMismatch(
                    MessageViewUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown MessageViewUnion type"))
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .messageView(let messageView):
                    try container.encode(messageView)
                case .deletedMessageView(let deletedMessageView):
                    try container.encode(deletedMessageView)
            }
        }
    }

    /// A reference containing the list of message logs.
    public enum MessageLogsUnion: Codable {
        case logBeginConversation(ChatBskyLexicon.Conversation.LogBeginConversation)
        case logLeaveConversation(ChatBskyLexicon.Conversation.LogLeaveConversation)
        case logCreateMessage(ChatBskyLexicon.Conversation.LogCreateMessage)
        case logDeleteMessage(ChatBskyLexicon.Conversation.LogDeleteMessage)
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            if let value = try? container.decode(ChatBskyLexicon.Conversation.LogBeginConversation.self) {
                self = .logBeginConversation(value)
            } else if let value = try? container.decode(ChatBskyLexicon.Conversation.LogLeaveConversation.self) {
                self = .logLeaveConversation(value)
            } else if let value = try? container.decode(ChatBskyLexicon.Conversation.LogCreateMessage.self) {
                self = .logCreateMessage(value)
            } else if let value = try? container.decode(ChatBskyLexicon.Conversation.LogDeleteMessage.self) {
                self = .logDeleteMessage(value)
            } else {
                throw DecodingError.typeMismatch(
                    MessageLogsUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown MessageLogsUnion type"))
            }
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            
            switch self {
                case .logBeginConversation(let logBeginConversation):
                    try container.encode(logBeginConversation)
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
