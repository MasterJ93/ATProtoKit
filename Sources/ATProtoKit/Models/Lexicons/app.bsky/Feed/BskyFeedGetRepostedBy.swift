//
//  BskyFeedGetRepostedBy.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-06.
//

import Foundation

/// The main data model definition for the output of retrieving an array of users who have reposted the given post.
///
/// - Note: According to the AT Protocol specifications: "Get a list of reposts for a given post."
///
/// - SeeAlso: This is based on the [`app.bsky.feed.getRepostedBy`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getRepostedBy.json
public struct FeedGetRepostedBy: Codable {
    /// The URI of the post record.
    public let postURI: String
    /// The CID hash of the post record.
    public let postCID: String?
    /// The mark used to indicate the starting point for the next set of results. Optional.
    public let cursor: String?
    /// An array of user accounts who reported the post record.
    public let repostedBy: [ActorProfileView]

    enum CodingKeys:String, CodingKey {
        case postURI = "uri"
        case postCID = "cid"
        case cursor
        case repostedBy
    }
}
