//
//  BskyFeedGetPosts.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-06.
//

import Foundation

/// The main data model definition for the output of getting a hydrated array of posts.
///
/// - Note: According to the AT Protocol specifications: "Gets post views for a specified list of posts (by AT-URI). This is sometimes referred to as 'hydrating'
/// a 'feed skeleton'."
///
/// - SeeAlso: This is based on the [`app.bsky.feed.getPosts`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getPosts.json
public struct FeedGetPostsOutput: Codable {
    /// An array of hydrated posts.
    public let posts: [FeedPostView]
}
