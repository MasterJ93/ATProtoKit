//
//  AppBskyFeedGetLikes.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-18.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Feed {

    /// An output model for etrieving like records of a specific subject.
    ///
    /// - Note: According to the AT Protocol specifications: "Get like records which reference a
    /// subject (by AT-URI and CID)."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getLikes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getLikes.json
    public struct GetLikesOutput: Sendable, Codable {

        /// The URI of the record.
        public let recordURI: String

        /// The CID hash of the record.
        public let recordCID: String?

        /// The mark used to indicate the starting point for the next set of results.
        public let cursor: String?

        /// An array of like records.
        public let likes: [Like]

        public init(recordURI: String, recordCID: String?, cursor: String?, likes: [Like]) {
            self.recordURI = recordURI
            self.recordCID = recordCID
            self.cursor = cursor
            self.likes = likes
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.recordURI = try container.decode(String.self, forKey: .recordURI)
            self.recordCID = try container.decodeIfPresent(String.self, forKey: .recordCID)
            self.cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
            self.likes = try container.decode([AppBskyLexicon.Feed.GetLikesOutput.Like].self, forKey: .likes)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.recordURI, forKey: .recordURI)
            try container.encodeIfPresent(self.recordCID, forKey: .recordCID)
            try container.encodeIfPresent(self.cursor, forKey: .cursor)
            try container.encode(self.likes, forKey: .likes)
        }
        
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
        public struct Like: Sendable, Codable {

            /// The date and time the like record was indexed.
            public let indexedAt: Date

            /// The date and time the like record was created.
            public let createdAt: Date

            /// The user that created the like record.
            public let actor: AppBskyLexicon.Actor.ProfileViewDefinition

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.indexedAt = try container.decodeDate(forKey: .indexedAt)
                self.createdAt = try container.decodeDate(forKey: .createdAt)
                self.actor = try container.decode(AppBskyLexicon.Actor.ProfileViewDefinition.self, forKey: .actor)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encodeDate(self.indexedAt, forKey: .indexedAt)
                try container.encodeDate(self.createdAt, forKey: .createdAt)
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
