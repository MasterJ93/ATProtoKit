//
//  BskyGraphGetRelationships.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-10.
//

import Foundation

/// The main data model definition for the output of the public relationship between two user accounts.
///
/// - Note: According to the AT Protocol specifications: "Enumerates public relationships between one account, and a list of other accounts. Does not require auth."
///
/// - SeeAlso: This is based on the [`app.bsky.graph.getRelationships`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getRelationships.json
public struct GraphGetRelationships: Codable {
    /// The decentralized identifier (DID) of the user account.
    public let actor: String?
    /// The metadata containing the relationship between mutliple user accounts.
    public let relationships: [GraphRelationshipUnion]
}


/// A reference containing the list of relationships of multiple user accounts.
public enum GraphRelationshipUnion: Codable {
    case relationship(GraphRelationship)
    case notFoundActor(GraphNotFoundActor)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(GraphRelationship.self) {
            self = .relationship(value)
        } else if let value = try? container.decode(GraphNotFoundActor.self) {
            self = .notFoundActor(value)
        } else {
            throw DecodingError.typeMismatch(
                ActorPreferenceUnion.self, DecodingError.Context(
                codingPath: decoder.codingPath, debugDescription: "Unknown GraphRelationshipUnion type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .relationship(let relationship):
                try container.encode(relationship)
            case .notFoundActor(let notFoundActor):
                try container.encode(notFoundActor)
        }
    }
}
