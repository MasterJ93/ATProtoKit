//
//  AppBskyFeedGetActorLikes.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-18.
//

import Foundation

extension AppBskyLexicon.Feed {

    /// An output model for seeing all of a user account's likes.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of posts liked by an actor.
    /// Requires auth, actor must be the requesting account."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getActorLikes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getActorLikes.json
    public struct GetActorLikesOutput: Codable {

        /// The mark used to indicate the starting point for the next set of result. Optional.
        public let cursor: String?

        /// An array of like records.
        public let feed: [AppBskyLexicon.Feed.FeedViewPostDefinition]
    }
}
