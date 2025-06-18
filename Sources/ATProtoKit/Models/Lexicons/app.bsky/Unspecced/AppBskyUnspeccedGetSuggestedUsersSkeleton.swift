//
//  AppBskyUnspeccedGetSuggestedUsersSkeleton.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-14.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// An output model for getting a skeleton version of suggested users.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a skeleton of suggested users. Intended to
    /// be called and hydrated by app.bsky.unspecced.getSuggestedUsers."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getSuggestedUsersSkeleton`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getSuggestedUsersSkeleton.json
    public struct GetSuggestedUsersSkeletonOutput: Sendable, Codable {

        /// An array of decentralized identifiers (DIDs) representing user accounts.
        public let userDIDs: [String]

        enum CodingKeys: String, CodingKey {
            case userDIDs = "dids"
        }
    }
}
