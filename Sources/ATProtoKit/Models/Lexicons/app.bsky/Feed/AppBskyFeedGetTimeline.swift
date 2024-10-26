//
//  AppBskyFeedGetTimeline.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Feed {

    /// An output model for getting the user account's timeline.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a view of the requesting account's
    /// home timeline. This is expected to be some form of reverse-chronological feed."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getTimeline`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getTimeline.json
    public struct GetTimelineOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of post records.
        public let feed: [FeedViewPostDefinition]
    }
}
