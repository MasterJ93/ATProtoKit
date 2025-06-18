//
//  AppBskyUnspeccedGetTrends.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-14.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// An output model for getting the current trends on Bluesky.
    ///
    /// - Note: According to the AT Protocol specifications: "Get the current trends on the network."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getTrends`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getTrends.json
    public struct GetTrendsOutput: Sendable, Codable {

        /// An array of trend views.
        public let trends: [AppBskyLexicon.Unspecced.TrendViewDefinition]
    }
}
