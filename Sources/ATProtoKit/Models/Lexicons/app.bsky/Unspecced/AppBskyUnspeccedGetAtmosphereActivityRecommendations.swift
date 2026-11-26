//
//  AppBskyUnspeccedGetAtmosphereActivityRecommendations.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// The main data model definition for getting a skeleton of recommended Atmosphere activity.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    public struct GetAtmosphereActivityRecommendations: Sendable, Codable {

        /// A skeleton item of recommended Atmosphere activity.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereActivityRecommendations`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereActivityRecommendations.json
        public struct Item: Sendable, Codable {

            /// The URI of the record.
            public let uri: String
        }
    }

    /// An output model for getting a skeleton of recommended Atmosphere activity.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get an ordered skeleton of recommended
    /// Standard.site articles and Grain galleries. Intended to be called and hydrated by
    /// app.bsky.unspecced.getAtmosphereRecommendedActivity."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereActivityRecommendations`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereActivityRecommendations.json
    public struct GetAtmosphereActivityRecommendationsOutput: Sendable, Codable {

        /// An array of skeleton items.
        public let items: [AppBskyLexicon.Unspecced.GetAtmosphereActivityRecommendations.Item]

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
