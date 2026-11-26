//
//  AppBskyUnspeccedGetAtmosphereExploreGalleryRecommendations.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// The main data model definition for getting a skeleton of recommended Atmosphere Explore
    /// Grain galleries.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    public struct GetAtmosphereExploreGalleryRecommendations: Sendable, Codable {

        /// A skeleton gallery.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereExploreGalleryRecommendations`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereExploreGalleryRecommendations.json
        public struct Gallery: Sendable, Codable {

            /// The URI of the gallery.
            public let uri: String
        }
    }

    /// An output model for getting a skeleton of recommended Atmosphere Explore Grain galleries.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a skeleton of recommended Atmosphere
    /// Explore Grain galleries. Intended to be called and hydrated by
    /// app.bsky.unspecced.getAtmosphereExploreTab."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereExploreGalleryRecommendations`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereExploreGalleryRecommendations.json
    public struct GetAtmosphereExploreGalleryRecommendationsOutput: Sendable, Codable {

        /// An array of skeleton galleries.
        public let galleries: [AppBskyLexicon.Unspecced.GetAtmosphereExploreGalleryRecommendations.Gallery]

        /// A Snowflake ID for recommendation events.
        ///
        /// - Note: According to the AT Protocol specifications: "Snowflake for this
        /// recommendation, use when submitting recommendation events."
        public let recommendationIDString: String

        enum CodingKeys: String, CodingKey {
            case galleries
            case recommendationIDString = "recIdStr"
        }
    }
}
