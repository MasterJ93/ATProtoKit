//
//  BskyFeedSendInteractions.swift
//
//
//  Created by Christopher Jr Riley on 2024-04-15.
//

import Foundation

/// The request body model definition for sending interactions to a feed generator.
///
/// - Note: According to the AT Protocol specifications: "end information about interactions with feed items back to the feed generator
/// that served them."
///
/// - SeeAlso: This is based on the [`app.bsky.feed.sendInteractions`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/sendInteractions.json
public struct FeedSendInteractions: Codable {
    /// An array of interactions.
    public let interactions: [FeedInteraction]
}

/// The output model definition for sending interactions to a feed generator.
///
/// - SeeAlso: This is based on the [`app.bsky.feed.sendInteractions`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/sendInteractions.json
public struct FeedSendInteractionsOutput: Codable {}
