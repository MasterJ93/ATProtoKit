//
//  AppBskyUnspeccedGetAtmosphereExploreArticleRecommendations.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// The main data model definition for getting a skeleton of recommended Atmosphere Explore articles.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    public struct GetAtmosphereExploreArticleRecommendations: Sendable, Codable {

        /// A skeleton article.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereExploreArticleRecommendations`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereExploreArticleRecommendations.json
        public struct Article: Sendable, Codable {

            /// The URI of the article.
            public let uri: String
        }
    }

    /// An output model for getting a skeleton of recommended Atmosphere Explore articles.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a skeleton of recommended Atmosphere
    /// Explore articles. Intended to be called and hydrated by
    /// app.bsky.unspecced.getAtmosphereExploreTab"
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereExploreArticleRecommendations`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereExploreArticleRecommendations.json
    public struct GetAtmosphereExploreArticleRecommendationsOutput: Sendable, Codable {

        /// An array of skeleton articles.
        public let articles: [AppBskyLexicon.Unspecced.GetAtmosphereExploreArticleRecommendations.Article]

        /// A Snowflake ID for recommendation events.
        ///
        /// - Note: According to the AT Protocol specifications: "Snowflake for this
        /// recommendation, use when submitting recommendation events."
        public let recommendationIDString: String

        enum CodingKeys: String, CodingKey {
            case articles
            case recommendationIDString = "recIdStr"
        }
    }
}
