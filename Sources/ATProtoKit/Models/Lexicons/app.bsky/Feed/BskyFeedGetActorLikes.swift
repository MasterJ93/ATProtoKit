//
//  BskyFeedGetActorLikes.swift
//  
//
//  Created by Christopher Jr Riley on 2024-03-04.
//

import Foundation

/// The main data model definition for the output of seeing all of a user account's likes.
///
/// - Note: According to the AT Protocol specifications: "Get a list of posts liked by an actor. Does not require auth."
///
/// - SeeAlso: This is based on the [`app.bsky.feed.getActorLikes`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getActorLikes.json
public struct FeedGetActorLikesOutput: Codable {
    /// The mark used to indicate the starting point for the next set of result. Optional.
    public let cursor: String?
    /// An array of like records.
    public let feed: [FeedViewPost]
}
