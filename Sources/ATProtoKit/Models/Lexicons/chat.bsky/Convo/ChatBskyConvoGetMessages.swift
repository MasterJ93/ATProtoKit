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
    public struct GetMessagesOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of messages.
        public let messages: [MessagesUnion]

        // Unions
        /// An array of messages.
        public enum MessagesUnion: ATUnionProtocol {

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
                    case .messageView(let messageView):
                        try container.encode(messageView)
                    case .deletedMessageView(let deletedMessageView):
                        try container.encode(deletedMessageView)
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
