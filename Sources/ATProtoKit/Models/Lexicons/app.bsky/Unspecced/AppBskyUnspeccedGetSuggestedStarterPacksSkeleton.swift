//
//  AppBskyUnspeccedGetSuggestedStarterPacksSkeleton.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-14.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// An output model for getting an array of suggested starter pack.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a skeleton of suggested starterpacks.
    /// Intended to be called and hydrated by app.bsky.unspecced.getSuggestedStarterpacks."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getSuggestedStarterPacksSkeleton`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getSuggestedStarterPacksSkeleton.json
    public struct GetSuggestedStarterPacksSkeletonOutput: Sendable, Codable {

        /// An array of starter pack URIs.
        public let starterPacks: [String]
    }
}
