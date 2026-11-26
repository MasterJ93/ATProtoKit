//
//  ChatBskyGroupGetJoinLinkPreviews.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Group {

    /// An output model for getting the previews of join links.
    ///
    /// - Note: According to the AT Protocol specifications: "Get public information about groups
    /// from join links. The output array matches the input codes one-to-one by position (and each
    /// view also carries its 'code'). Disabled codes return a disabledJoinLinkPreviewView, and
    /// codes that do not map to a previewable link return an invalidJoinLinkPreviewView."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.getJoinLinkPreviews`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/getJoinLinkPreviews.json
    public struct GetJoinLinkPreviewsOutput: Sendable, Codable {

        /// An array of join link previews.
        public let joinLinkPreviews: [JoinLinkPreviewsUnion]

        // Unions
        /// An array of join link previews.
        public enum JoinLinkPreviewsUnion: ATUnionProtocol {

            /// A join link preview view.
            case joinLinkPreviewView(ChatBskyLexicon.Group.JoinLinkPreviewViewDefinition)

            /// A disabled join link preview view.
            case disabledJoinLinkPreviewView(ChatBskyLexicon.Group.DisabledJoinLinkPreviewViewDefinition)

            /// An invalid join link preview view.
            case invalidJoinLinkPreviewView(ChatBskyLexicon.Group.InvalidJoinLinkPreviewViewDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
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

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .joinLinkPreviewView(let joinLinkPreviewView):
                        try container.encode(joinLinkPreviewView)
                    case .disabledJoinLinkPreviewView(let disabledJoinLinkPreviewView):
                        try container.encode(disabledJoinLinkPreviewView)
                    case .invalidJoinLinkPreviewView(let invalidJoinLinkPreviewView):
                        try container.encode(invalidJoinLinkPreviewView)
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
