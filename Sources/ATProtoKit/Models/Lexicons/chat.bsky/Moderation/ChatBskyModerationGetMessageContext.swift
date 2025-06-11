//
//  ChatBskyModerationGetMessageContext.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Moderation {

    /// An output model for getting the message context.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.moderation.getMessageContext`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/moderation/getMessageContext.json
    public struct GetMessageContextOutput: Sendable, Codable {

        /// An array of messages.
        public let messages: [MessageUnion]

        // Unions
        /// An array of messages.
        public enum MessageUnion: ATUnionProtocol {

            /// A message view.
            case messageView(ChatBskyLexicon.Conversation.MessageViewDefinition)

            /// A deleted message view.
            case deletedMessageView(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decode(String.self, forKey: .type)

                switch type {
                    case "chat.bsky.convo.defs#messageView":
                        self = .messageView(try ChatBskyLexicon.Conversation.MessageViewDefinition(from: decoder))
                    case "chat.bsky.convo.defs#deletedMessageView":
                        self = .deletedMessageView(try ChatBskyLexicon.Conversation.DeletedMessageViewDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type, dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .messageView(let value):
                        try container.encode(value)
                    case .deletedMessageView(let value):
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
