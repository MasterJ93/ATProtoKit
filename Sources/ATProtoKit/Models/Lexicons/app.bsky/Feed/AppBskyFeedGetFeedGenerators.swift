//
//  AppBskyFeedGetFeedGenerators.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-18.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Feed {

    /// An output model for getting information about several feed generators.
    ///
    /// - Note: According to the AT Protocol specifications: "Get information about a list of
    /// feed generators."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getFeedGenerators`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getFeedGenerator.json
    public struct GetFeedGeneratorsOutput: Sendable, Codable {

        /// An array of feed generators.
        public let feeds: [GeneratorViewDefinition]
    }
}
