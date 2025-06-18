//
//  AppBskyFeedRepost.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Feed {

    /// The record model definition for a repost record on Bluesky.
    ///
    /// - Note: According to the AT Protocol specifications: "Record representing a 'repost' of an
    /// existing Bluesky post."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.repost`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/repost.json
    public struct RepostRecord: ATRecordProtocol, Sendable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.feed.repost"

        /// The strong reference of the repost record.
        public let subject: ComAtprotoLexicon.Repository.StrongReference

        /// The date the repost record was created.
        ///
        /// This is the date where the user "reposted" a post.
        public let createdAt: Date

        /// A strong reference of a referred repost. Optional.
        public let via: ComAtprotoLexicon.Repository.StrongReference?

        public init(subject: ComAtprotoLexicon.Repository.StrongReference, createdAt: Date, via: ComAtprotoLexicon.Repository.StrongReference?) {
            self.subject = subject
            self.createdAt = createdAt
            self.via = via
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.subject = try container.decode(ComAtprotoLexicon.Repository.StrongReference.self, forKey: .subject)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
            self.via = try container.decodeIfPresent(ComAtprotoLexicon.Repository.StrongReference.self, forKey: .via)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.subject, forKey: .subject)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
            try container.encodeIfPresent(self.via, forKey: .via)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case subject
            case createdAt
            case via
        }
    }
}
