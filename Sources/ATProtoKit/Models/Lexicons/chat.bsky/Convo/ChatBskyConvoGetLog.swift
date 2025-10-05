//
//  ChatBskyConvoGetLog.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Conversation {

    /// An output model for getting logs for messages.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.getLog`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/getLog.json
    public struct GetLogOutput: ATUnionProtocol {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of logs.
        public let logs: [LogsUnion]

        // Unions
        /// A reference containing the list of message logs.
        public enum LogsUnion: ATUnionProtocol {

            /// A log entry for beginning the coversation.
            case beginConversation(ChatBskyLexicon.Conversation.LogBeginConversationDefinition)

            /// A log entry for accepting a conversation.
            case acceptConversation(ChatBskyLexicon.Conversation.LogAcceptConversationDefinition)

            /// A log entry for leaving the conversation.
            case leaveConversation(ChatBskyLexicon.Conversation.LogLeaveConversationDefinition)

            /// A log entry for muting a conversation.
            case muteConversation(ChatBskyLexicon.Conversation.LogMuteConversationDefinition)

            /// A log entry for unmute a conversation.
            case unmuteConversation(ChatBskyLexicon.Conversation.LogUnmuteConversationDefinition)

            /// A log entry for creating a message.
            case createMessage(ChatBskyLexicon.Conversation.LogCreateMessageDefinition)

            /// A log entry for deleting a message.
            case deleteMessage(ChatBskyLexicon.Conversation.LogDeleteMessageDefinition)

            /// A log entry for reading a message.
            case readMessage(ChatBskyLexicon.Conversation.LogReadMessageDefinition)

            /// A log entry for adding a reaction.
            case addReaction(ChatBskyLexicon.Conversation.LogAddReactionViewDefinition)

            /// A log entry for removing a reaction.
            case removeReaction(ChatBskyLexicon.Conversation.LogRemoveReactionDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "chat.bsky.convo.defs#logBeginConvo":
                        self = .beginConversation(try ChatBskyLexicon.Conversation.LogBeginConversationDefinition(from: decoder))
                    case "chat.bsky.convo.defs#logAcceptConvo":
                        self = .acceptConversation(try ChatBskyLexicon.Conversation.LogAcceptConversationDefinition(from: decoder))
                    case "chat.bsky.convo.defs#logLeaveConvo":
                        self = .leaveConversation(try ChatBskyLexicon.Conversation.LogLeaveConversationDefinition(from: decoder))
                    case "chat.bsky.convo.defs#logMuteConvo":
                        self = .muteConversation(try ChatBskyLexicon.Conversation.LogMuteConversationDefinition(from: decoder))
                    case "chat.bsky.convo.defs#logUnmuteConvo":
                        self = .unmuteConversation(try ChatBskyLexicon.Conversation.LogUnmuteConversationDefinition(from: decoder))
                    case "chat.bsky.convo.defs#logCreateMessage":
                        self = .createMessage(try ChatBskyLexicon.Conversation.LogCreateMessageDefinition(from: decoder))
                    case "chat.bsky.convo.defs#logDeleteMessage":
                        self = .deleteMessage(try ChatBskyLexicon.Conversation.LogDeleteMessageDefinition(from: decoder))
                    case "chat.bsky.convo.defs#logReadMessage":
                        self = .readMessage(try ChatBskyLexicon.Conversation.LogReadMessageDefinition(from: decoder))
                    case "chat.bsky.convo.defs#logAddReaction":
                        self = .addReaction(try ChatBskyLexicon.Conversation.LogAddReactionViewDefinition(from: decoder))
                    case "chat.bsky.convo.defs#logRemoveReaction":
                        self = .removeReaction(try ChatBskyLexicon.Conversation.LogRemoveReactionDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .beginConversation(let value):
                        try container.encode(value)
                    case .acceptConversation(let value):
                        try container.encode(value)
                    case .leaveConversation(let value):
                        try container.encode(value)
                    case .muteConversation(let value):
                        try container.encode(value)
                    case .unmuteConversation(let value):
                        try container.encode(value)
                    case .createMessage(let value):
                        try container.encode(value)
                    case .deleteMessage(let value):
                        try container.encode(value)
                    case .readMessage(let value):
                        try container.encode(value)
                    case .addReaction(let value):
                        try container.encode(value)
                    case .removeReaction(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }
    }
}
