//
//  BskyFeedGetFeedGenerators.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-04.
//

import Foundation

/// The main data model definition for the output of getting information about several
/// feed generators.
///
/// - Note: According to the AT Protocol specifications: "Get information about a list of
/// feed generators."
///
/// - SeeAlso: This is based on the [`app.bsky.feed.getFeedGenerators`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getFeedGenerator.json
public struct FeedGetFeedGeneratorsOutput: Codable {
    /// An array of feed generators.
    public let feeds: [FeedGeneratorView]
}
