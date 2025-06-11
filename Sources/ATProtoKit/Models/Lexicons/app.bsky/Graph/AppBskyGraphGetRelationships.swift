//
//  AppBskyGraphGetRelationships.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Graph {

    /// An output model for the public relationship between two user accounts.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates public relationships between
    /// one account, and a list of other accounts. Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getRelationships`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getRelationships.json
    public struct GetRelationshipsOutput: Sendable, Codable {

        /// The decentralized identifier (DID) of the user account.
        public let actorDID: String?

        /// The metadata containing the relationship between mutliple user accounts.
        public let relationships: [RelationshipsUnion]

        enum CodingKeys: String, CodingKey {
            case actorDID = "actor"
            case relationships
        }

        // Unions
        /// The metadata containing the relationship between mutliple user accounts.
        public enum RelationshipsUnion: ATUnionProtocol {

            /// The relationship between two user accounts.
            case relationship(AppBskyLexicon.Graph.RelationshipDefinition)

            /// Indicates the user account is not found.
            case notFoundActor(AppBskyLexicon.Graph.NotFoundActorDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decode(String.self, forKey: .type)

                switch type {
                    case "app.bsky.graph.defs#relationship":
                        self = .relationship(try AppBskyLexicon.Graph.RelationshipDefinition(from: decoder))
                    case "app.bsky.graph.defs#notFoundActor":
                        self = .notFoundActor(try AppBskyLexicon.Graph.NotFoundActorDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type, dictionary)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .relationship(let relationship):
                        try container.encode(relationship)
                    case .notFoundActor(let notFoundActor):
                        try container.encode(notFoundActor)
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
