//
//  AppBskyUnspeccedGetSuggestedFeedsSkeleton.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-14.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// An output model for getting an array of URIs for suggested feeds.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a skeleton of suggested feeds.
    /// Intended to be called and hydrated by app.bsky.unspecced.getSuggestedFeeds."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getSuggestedFeedsSkeleton`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getSuggestedFeedsSkeleton.json
    public struct GetSuggestedFeedsSkeletonOutput: Sendable, Codable {

        /// An array of feed URIs.
        public let feedURIs: [String]

        enum CodingKeys: String, CodingKey {
            case feedURIs = "feeds"
        }
    }
}
