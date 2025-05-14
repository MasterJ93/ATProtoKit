//
//  AppBskyUnspeccedGetTrendsSkeleton.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-14.
//

import Foundation

extension AppBskyLexicon.Unspecced {

    /// An output model for getting the skeleton of trends on Bluesky.
    ///
    /// - Note: According to the AT Protocol specifications: "Get the skeleton of trends on the network.
    /// Intended to be called and then hydrated through app.bsky.unspecced.getTrends."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getTrendsSkeleton`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getTrendsSkeleton.json
    public struct GetTrendsSkeletonOutput: Sendable, Codable {

        /// An array of skeleton trends.
        public let trends: [AppBskyLexicon.Unspecced.SkeletonTrendDefinition]
    }
}
