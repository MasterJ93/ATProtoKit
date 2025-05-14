//
//  AppBskyUnspeccedGetSuggestedFeeds.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-14.
//

import Foundation

extension AppBskyLexicon.Unspecced {

    /// An output model for getting an array of suggested feeds.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of suggested feeds."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getSuggestedFeeds`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getSuggestedFeeds.json
    public struct GetSuggestedFeedsOutput: Sendable, Codable {

        /// An array of feeds.
        public let feeds: [AppBskyLexicon.Feed.GeneratorViewDefinition]
    }
}
