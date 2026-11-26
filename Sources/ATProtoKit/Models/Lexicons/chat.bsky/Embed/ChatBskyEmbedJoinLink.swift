//
//  ChatBskyEmbedJoinLink.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Embed {

    /// A definition model for join link embeds.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.embed.joinLink`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/embed/joinLink.json
    public struct JoinLinkDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "chat.bsky.embed.joinLink"

        /// The code of the join link.
        ///
        /// - Note: According to the AT Protocol specifications: "The join link code."
        public let code: String

        public init(code: String) {
            self.code = code
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.code = try container.decode(String.self, forKey: CodingKeys.code)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.type, forKey: CodingKeys.type)
            try container.encode(self.code, forKey: CodingKeys.code)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case code
        }

        // Enums
        /// A data model for a view definition.
        ///
        /// - SeeAlso: This is based on the [`chat.bsky.embed.joinLink`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/embed/joinLink.json
        public struct View: Sendable, Codable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "chat.bsky.embed.joinLink#view"

            /// The preview of the join link.
            public let joinLinkPreview: JoinLinkPreviewUnion

            public init(joinLinkPreview: JoinLinkPreviewUnion) {
                self.joinLinkPreview = joinLinkPreview
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.joinLinkPreview = try container.decode(JoinLinkPreviewUnion.self, forKey: CodingKeys.joinLinkPreview)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.type, forKey: CodingKeys.type)
                try container.encode(self.joinLinkPreview, forKey: CodingKeys.joinLinkPreview)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case joinLinkPreview
            }

            // Unions
            /// A reference containing the preview of the join link.
            public indirect enum JoinLinkPreviewUnion: ATUnionProtocol {

                /// A join link preview view.
                case joinLinkPreviewView(ChatBskyLexicon.Group.JoinLinkPreviewViewDefinition)

                /// A disabled join link preview view.
                case disabledJoinLinkPreviewView(ChatBskyLexicon.Group.DisabledJoinLinkPreviewViewDefinition)

                /// An invalid join link preview view.
                case invalidJoinLinkPreviewView(ChatBskyLexicon.Group.InvalidJoinLinkPreviewViewDefinition)

                /// An unknown case.
                case unknown(String, [String: CodableValue])

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let type = try container.decodeIfPresent(String.self, forKey: .type)

                    switch type {
                        case "chat.bsky.group.defs#joinLinkPreviewView":
                            self = .joinLinkPreviewView(try ChatBskyLexicon.Group.JoinLinkPreviewViewDefinition(from: decoder))
                        case "chat.bsky.group.defs#disabledJoinLinkPreviewView":
                            self = .disabledJoinLinkPreviewView(try ChatBskyLexicon.Group.DisabledJoinLinkPreviewViewDefinition(from: decoder))
                        case "chat.bsky.group.defs#invalidJoinLinkPreviewView":
                            self = .invalidJoinLinkPreviewView(try ChatBskyLexicon.Group.InvalidJoinLinkPreviewViewDefinition(from: decoder))
                        default:
                            let singleValueDecodingContainer = try decoder.singleValueContainer()
                            let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                            self = .unknown(type ?? "unknown", dictionary)
                    }
                }

                public func encode(to encoder: Encoder) throws {
                    switch self {
                        case .joinLinkPreviewView(let value):
                            var container = encoder.container(keyedBy: CodingKeys.self)
                            try container.encode("chat.bsky.group.defs#joinLinkPreviewView", forKey: .type)
                            try value.encode(to: encoder)
                        case .disabledJoinLinkPreviewView(let value):
                            var container = encoder.container(keyedBy: CodingKeys.self)
                            try container.encode("chat.bsky.group.defs#disabledJoinLinkPreviewView", forKey: .type)
                            try value.encode(to: encoder)
                        case .invalidJoinLinkPreviewView(let value):
                            var container = encoder.container(keyedBy: CodingKeys.self)
                            try container.encode("chat.bsky.group.defs#invalidJoinLinkPreviewView", forKey: .type)
                            try value.encode(to: encoder)
                        case .unknown(_, let dictionary):
                            var singleValueContainer = encoder.singleValueContainer()
                            try singleValueContainer.encode(dictionary)
                    }
                }

                enum CodingKeys: String, CodingKey {
                    case type = "$type"
                }
            }
        }
    }
}
