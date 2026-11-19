//
//  ChatBskyConvoListConvoRequests.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Conversation {

    /// An output model for listing various conversation requests.
    ///
    /// - Note: According to the AT Protocol specifications: "Returns a page of incoming
    /// conversation requests for the user. Direct convo requests are returned as convoView; group
    /// join requests made by the user are returned as joinRequestConvoView."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.listConvoRequests`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/convo/listConvoRequests.json
    public struct ListConversationRequestsOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of conversation requests.
        public let requests: [RequestsUnion]

        // Unions
        /// An array of conversation requests.
        public enum RequestsUnion: ATUnionProtocol {

            /// A conversation view.
            case conversationView(ChatBskyLexicon.Conversation.ConversationViewDefinition)

            /// A join request's conversation view.
            case joinRequestConversationView(ChatBskyLexicon.Group.JoinRequestConversationViewDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "chat.bsky.convo.defs#convoView":
                        self = .conversationView(try ChatBskyLexicon.Conversation.ConversationViewDefinition(from: decoder))
                    case "chat.bsky.group.defs#joinRequestConvoView":
                        self = .joinRequestConversationView(try ChatBskyLexicon.Group.JoinRequestConversationViewDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .conversationView(let conversationView):
                        try container.encode(conversationView)
                    case .joinRequestConversationView(let joinRequestConversationView):
                        try container.encode(joinRequestConversationView)
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
