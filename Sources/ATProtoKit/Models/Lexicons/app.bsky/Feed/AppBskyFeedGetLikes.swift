//
//  AppBskyFeedGetLikes.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-18.
//

import Foundation

extension AppBskyLexicon.Feed {

    /// An output model for etrieving like records of a specific subject.
    ///
    /// - Note: According to the AT Protocol specifications: "Get like records which reference a
    /// subject (by AT-URI and CID)."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getLikes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getLikes.json
    public struct GetLikesOutput: Codable {

        /// The URI of the record.
        public let recordURI: String

        /// The CID hash of the record.
        public let recordCID: String?

        /// The mark used to indicate the starting point for the next set of results.
        public let cursor: String?

        /// An array of like records.
        public let likes: [Like]

        enum CodingKeys: String, CodingKey {
            case recordURI = "uri"
            case recordCID = "cid"
            case cursor
            case likes
        }
        
        // Enums
        /// A data model definition of the like record itself.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.feed.getLikes`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getLikes.json
        public struct Like: Codable {

            /// The date and time the like record was indexed.
            @DateFormatting public var indexedAt: Date

            /// The date and time the like record was created.
            @DateFormatting public var createdAt: Date

            /// The user that created the like record.
            public let actor: AppBskyLexicon.Actor.ProfileViewDefinition

            public init(indexedAt: Date, createdAt: Date, actor: AppBskyLexicon.Actor.ProfileViewDefinition) {
                self._indexedAt = DateFormatting(wrappedValue: indexedAt)
                self._createdAt = DateFormatting(wrappedValue: createdAt)
                self.actor = actor
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
                self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
                self.actor = try container.decode(AppBskyLexicon.Actor.ProfileViewDefinition.self, forKey: .actor)
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self._indexedAt, forKey: .indexedAt)
                try container.encode(self._createdAt, forKey: .createdAt)
                try container.encode(self.actor, forKey: .actor)
            }

            public enum CodingKeys: CodingKey {
                case indexedAt
                case createdAt
                case actor
            }
        }
    }
}
