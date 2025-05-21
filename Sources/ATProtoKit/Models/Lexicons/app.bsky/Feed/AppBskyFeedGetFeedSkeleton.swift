//
//  AppBskyFeedGetFeedSkeleton.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-18.
//

import Foundation

extension AppBskyLexicon.Feed {

    /// An output model for getting a skeleton for a feed generator.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a skeleton of a feed provided
    /// by a feed generator. Auth is optional, depending on provider requirements, and provides the
    /// DID of the requester. Implemented by Feed Generator Service."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getFeedSkeleton`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getFeedSkeleton.json
    public struct GetFeedSkeletonOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of result. Optional.
        public let cursor: String?

        /// An array of skeleton feeds.
        public let feed: [SkeletonFeedPostDefinition]

        /// An interaction identifier that may be given upon an interaction.
        ///
        /// - Note: According to the AT Protocol specifications: "Unique identifier per request that may be
        /// passed back alongside interactions."
        public let requestID: String?

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(self.cursor, forKey: .cursor)
            try container.encode(self.feed, forKey: .feed)
            try container.truncatedEncodeIfPresent(self.requestID, forKey: .requestID, upToCharacterLength: 100)
        }

        enum CodingKeys: String, CodingKey {
            case cursor
            case feed
            case requestID = "reqId"
        }
    }
}
