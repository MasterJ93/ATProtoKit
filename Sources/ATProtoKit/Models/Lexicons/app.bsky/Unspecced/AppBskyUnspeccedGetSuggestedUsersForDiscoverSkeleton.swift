//
//  AppBskyUnspeccedGetSuggestedUsersForDiscoverSkeleton.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// An output model for getting a skeleton version of suggested users for the Discover page.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a skeleton of suggested users for the
    /// Discover page. Intended to be called and hydrated by
    /// app.bsky.unspecced.getSuggestedUsersForDiscover"
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getSuggestedUsersForDiscoverSkeleton`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getSuggestedUsersForDiscoverSkeleton.json
    public struct GetSuggestedUsersForDiscoverSkeletonOutput: Sendable, Codable {

        /// An array of decentralized identifiers (DIDs) representing user accounts.
        public let userDIDs: [String]

        /// A Snowflake ID for recommendation events. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Snowflake for this
        /// recommendation, use when submitting recommendation events."
        public let recommendationIDString: String?

        enum CodingKeys: String, CodingKey {
            case userDIDs = "dids"
            case recommendationIDString = "recIdStr"
        }
    }
}
