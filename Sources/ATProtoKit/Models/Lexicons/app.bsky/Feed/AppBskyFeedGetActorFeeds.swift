//
//  AppBskyFeedGetActorFeeds.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-18.
//

import Foundation

extension AppBskyLexicon.Feed {

    /// The main data model definition for the output of retrieving a feed list by a user.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of feeds (feed generator
    /// records) created by the actor (in the actor's repo)."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getActorFeeds`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getActorFeeds.json
    public struct GetActorFeedsOutput: Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of feeds.
        public let feeds: [GeneratorViewDefinition]
    }
}
