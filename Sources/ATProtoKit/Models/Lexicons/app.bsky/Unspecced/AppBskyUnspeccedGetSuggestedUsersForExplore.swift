//
//  AppBskyUnspeccedGetSuggestedUsersForExplore.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// An output model for getting an array of suggested user accounts for the Explore page.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of suggested users for the
    /// Explore page"
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getSuggestedUsersForExplore`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getSuggestedUsersForExplore.json
    public struct GetSuggestedUsersForExploreOutput: Sendable, Codable {

        /// An array of user accounts.
        public let actors: [AppBskyLexicon.Actor.ProfileViewDefinition]

        /// A Snowflake ID for recommendation events. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Snowflake for this
        /// recommendation, use when submitting recommendation events."
        public let recommendationIDString: String?

        enum CodingKeys: String, CodingKey {
            case actors
            case recommendationIDString = "recIdStr"
        }
    }
}
