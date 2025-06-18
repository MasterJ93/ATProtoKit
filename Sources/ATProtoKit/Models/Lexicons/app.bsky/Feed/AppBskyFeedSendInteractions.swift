//
//  AppBskyFeedSendInteractions.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Feed {

    /// The request body model definition for sending interactions to a feed generator.
    ///
    /// - Note: According to the AT Protocol specifications: "end information about interactions with
    /// feed items back to the feed generator that served them."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.sendInteractions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/sendInteractions.json
    public struct SendInteractionsRequestBody: Sendable, Codable {

        /// An array of interactions.
        public let interactions: [InteractionDefinition]
    }

    /// An output model for sending interactions to a feed generator.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.sendInteractions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/sendInteractions.json
    public struct SendInteractionsOutput: Sendable, Codable {}
}
