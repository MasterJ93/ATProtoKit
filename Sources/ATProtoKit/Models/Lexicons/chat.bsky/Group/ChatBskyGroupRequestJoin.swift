//
//  ChatBskyGroupRequestJoin.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Group {

    /// A request body model for requesting to join a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Sends a request to join a group (via
    /// join link) to the group owner. Action taken by the prospective group member."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.requestJoin`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/requestJoin.json
    public struct RequestJoinRequestBody: Sendable, Codable {

        /// The code of the join link.
        public let code: String
    }

    /// An output model for requesting to join a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Sends a request to join a group (via
    /// join link) to the group owner. Action taken by the prospective group member."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.requestJoin`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/requestJoin.json
    public struct RequestJoinOutput: Sendable, Codable {

        /// The status of the request to join the group conversation.
        public let status: Status

        /// The group conversation the user account has joined. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The group convo joined. This is
        /// only present in the case of status=joined"
        public let conversation: ChatBskyLexicon.Conversation.ConversationViewDefinition?

        enum CodingKeys: String, CodingKey {
            case status
            case conversation = "convo"
        }

        // Enums
        /// The status of the request to join the group conversation.
        public enum Status: Sendable, Codable, ExpressibleByStringLiteral {

            /// The user account has joined the group conversation.
            case joined

            /// The request to join the group conversation is pending.
            case pending

            /// An unknown value that the object may contain.
            case unknown(String)

            public var rawValue: String {
                switch self {
                    case .joined:
                        return "joined"
                    case .pending:
                        return "pending"
                    case .unknown(let value):
                        return value
                }
            }

            public init(stringLiteral value: String) {
                self = .unknown(value)
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let value = try container.decode(String.self)

                switch value {
                    case "joined":
                        self = .joined
                    case "pending":
                        self = .pending
                    default:
                        self = .unknown(value)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encode(self.rawValue)
            }
        }
    }
}
