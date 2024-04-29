//
//  BskyFeedGetFeedGenerator.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-04.
//

import Foundation

/// The main data model definition for the output of getting information about a given
/// feed generator.
///
/// - Note: According to the AT Protocol specifications: "Get information about a feed
/// generator. Implemented by AppView."
///
/// - SeeAlso: This is based on the [`app.bsky.feed.getFeedGenerator`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getFeedGenerator.json
public struct FeedGetFeedGeneratorOutput: Codable {
    /// The general information about the feed generator..
    public let view: FeedGeneratorView
    /// Indicates whether the feed generator is currently online.
    ///
    /// - Note: According to the AT Protocol specifications: "Indicates whether the feed generator
    /// service has been online recently, or else seems to be inactive."
    public let isOnline: Bool
    /// Indicates whether the feed generator is compatible with the record declaration.
    ///
    /// - Note: According to the AT Protocol specifications: "Indicates whether the feed generator
    /// service is compatible with the record declaration."
    public let isValid: Bool

}
