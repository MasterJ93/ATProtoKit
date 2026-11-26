//
//  AppBskyUnspeccedGetSuggestedOnboardingUsers.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// An output model for getting an array of suggested user accounts for onboarding.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of suggested users for
    /// onboarding"
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getSuggestedOnboardingUsers`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getSuggestedOnboardingUsers.json
    public struct GetSuggestedOnboardingUsersOutput: Sendable, Codable {

        /// An array of user accounts.
        public let actors: [AppBskyLexicon.Actor.ProfileViewDefinition]

        /// A Snowflake ID for recommendation events. Optional.
        ///
        /// - Important: This property is deprecated. Use ``recommendationIDString`` instead.
        ///
        /// - Note: According to the AT Protocol specifications: "DEPRECATED: use recIdStr instead."
        public let recommendationID: String?

        /// A Snowflake ID for recommendation events. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Snowflake for this
        /// recommendation, use when submitting recommendation events."
        public let recommendationIDString: String?

        enum CodingKeys: String, CodingKey {
            case actors
            case recommendationID = "recId"
            case recommendationIDString = "recIdStr"
        }
    }
}
