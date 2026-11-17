//
//  AppBskyActorContentVisibilityDeclaration.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-17.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Actor {

    /// A record model for an account's content visibility declaration.
    ///
    /// - Note: According to the AT Protocol specifications: "A declaration of an account's
    /// preferences for appearing in content discovery surfaces."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.contentVisibilityDeclaration`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/actor/contentVisibilityDeclaration.json
    public struct ContentVisibilityDeclarationRecord: ATRecordProtocol, Sendable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.actor.contentVisibilityDeclaration"

        /// Indicates whether the user account requests that its posts be hidden from
        /// algorithmic recommendations.
        ///
        /// - Note: According to the AT Protocol specifications: "Whether the account requests that
        /// its posts be hidden from algorithmic recommendations. Consumers must treat a missing
        /// record as false."
        public let isHiddenFromAlgorithmicRecommendations: Bool

        public init(isHiddenFromAlgorithmicRecommendations: Bool) {
            self.isHiddenFromAlgorithmicRecommendations = isHiddenFromAlgorithmicRecommendations
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.isHiddenFromAlgorithmicRecommendations = try container.decode(Bool.self, forKey: .isHiddenFromAlgorithmicRecommendations)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(AppBskyLexicon.Actor.ContentVisibilityDeclarationRecord.type, forKey: .type)
            try container.encode(self.isHiddenFromAlgorithmicRecommendations, forKey: .isHiddenFromAlgorithmicRecommendations)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case isHiddenFromAlgorithmicRecommendations = "hideFromAlgorithmicRecommendations"
        }
    }
}
