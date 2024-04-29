//
//  BskyFeedDescribeFeedGenerator.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-03.
//

import Foundation

// TODO: Figure out a proper way of doing this.
/// A data model definition for the output ofretrieving information about a feed generator.
///
/// - Note: According to the AT Protocol specifications: "Get information about a feed generator,
/// including policies and offered feed URIs. Does not require auth; implemented by
/// Feed Generator services (not App View)."
///
/// - SeeAlso: This is based on the [`app.bsky.feed.describeFeedGenerator`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/describeFeedGenerator.json
public struct FeedDescribeFeedGeneratorOutput: Codable {
    /// The decentralized identifier (DID) of the feed generator.
    public let atDID: String
    /// An array of feed generators.
    public let feeds: [FeedDescribeFeedGeneratorFeed]
    /// The URL of the Privacy Policy and Terms of Service. Optional.
    public let links: FeedDescribeFeedGeneratorLinks?

    enum CodingKeys: String, CodingKey {
        case atDID = "did"
        case feeds
        case links
    }
}

/// A data model definiion for the feed generator.
public struct FeedDescribeFeedGeneratorFeed: Codable {
    /// The URI of the feed.
    public let feedURI: String

    enum CodingKeys: String, CodingKey {
        case feedURI = "uri"
    }
}

/// A data model definition for the Privacy Policy and Terms of Service URLs.
public struct FeedDescribeFeedGeneratorLinks: Codable {
    /// The URL to the Privacy Policy.
    public let privacyPolicy: URL
    /// The URL to the Terms of Service.
    public let termsOfService: URL
}
