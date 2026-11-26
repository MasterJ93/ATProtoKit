//
//  AppBskyUnspeccedGetAtmosphereRecommendedActivity.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// The main data model definition for getting recommended Atmosphere activity.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    public struct GetAtmosphereRecommendedActivity: Sendable, Codable {

        /// An item of recommended Atmosphere activity.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereRecommendedActivity`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereRecommendedActivity.json
        public struct Item: Sendable, Codable {

            /// The view of the item.
            public let view: ViewUnion

            // Unions
            /// The view of the item.
            public enum ViewUnion: ATUnionProtocol {

                /// The view of an article.
                case viewArticle(AppBskyLexicon.Embed.ExternalDefinition.ViewArticle)

                /// The view of a gallery.
                case viewGallery(AppBskyLexicon.Embed.ExternalDefinition.ViewGallery)

                /// An unknown case.
                case unknown(String, [String: CodableValue])

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let type = try container.decodeIfPresent(String.self, forKey: .type)

                    switch type {
                        case "app.bsky.embed.external#viewArticle":
                            self = .viewArticle(try AppBskyLexicon.Embed.ExternalDefinition.ViewArticle(from: decoder))
                        case "app.bsky.embed.external#viewGallery":
                            self = .viewGallery(try AppBskyLexicon.Embed.ExternalDefinition.ViewGallery(from: decoder))
                        default:
                            let singleValueDecodingContainer = try decoder.singleValueContainer()
                            let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                            self = .unknown(type ?? "unknown", dictionary)
                    }
                }

                public func encode(to encoder: any Encoder) throws {
                    var container = encoder.singleValueContainer()

                    switch self {
                        case .viewArticle(let value):
                            try container.encode(value)
                        case .viewGallery(let value):
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

    /// An output model for getting recommended Atmosphere activity.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get recommended Standard.site articles
    /// and Grain galleries for Atmosphere Activity in recommendation order. Authentication is
    /// optional. Unavailable items are omitted, so the response may contain fewer than the
    /// requested limit."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereRecommendedActivity`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereRecommendedActivity.json
    public struct GetAtmosphereRecommendedActivityOutput: Sendable, Codable {

        /// An array of recommended items.
        public let items: [AppBskyLexicon.Unspecced.GetAtmosphereRecommendedActivity.Item]

        /// A Snowflake ID for recommendation events.
        ///
        /// - Note: According to the AT Protocol specifications: "Snowflake for this
        /// recommendation, use when submitting recommendation events."
        public let recommendationIDString: String

        enum CodingKeys: String, CodingKey {
            case items
            case recommendationIDString = "recIdStr"
        }
    }
}
