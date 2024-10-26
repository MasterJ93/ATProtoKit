//
//  AppBskyFeedThreadgate.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Feed {

    /// A record model for a threadgate.
    ///
    /// - Note: According to the AT Protocol specifications: "Record defining interaction gating rules
    /// for a thread (aka, reply controls). The record key (rkey) of the threadgate record must match
    /// the record key of the thread's root post, and that record must be in the same repository."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.threadgate`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/threadgate.json
    public struct ThreadgateRecord: ATRecordProtocol {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static private(set) var type: String = "app.bsky.feed.threadgate"

        /// The URI of a post record.
        ///
        /// - Note: According to the AT Protocol specifications: "Reference (AT-URI) to the
        /// post record."
        public let post: String

        /// An array of rules used as an allowlist.
        public let allow: [ATUnion.ThreadgateUnion]?

        /// The date and time of the creation of the threadgate.
        @DateFormatting public var createdAt: Date

        /// An array of hidden replies in the form of URIs. Optional.
        public let hiddenReplies: [String]?

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.post = try container.decode(String.self, forKey: .post)
            self.allow = try container.decodeIfPresent([ATUnion.ThreadgateUnion].self, forKey: .allow)
            self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
            self.hiddenReplies = try container.decodeIfPresent([String].self, forKey: .hiddenReplies)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.post, forKey: .post)
            try container.encodeIfPresent(self.allow, forKey: .allow)
            try container.encode(self._createdAt, forKey: .createdAt)

            try truncatedEncodeIfPresent(self.hiddenReplies, withContainer: &container, forKey: .hiddenReplies, upToArrayLength: 50)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case post
            case allow
            case createdAt
            case hiddenReplies
        }

        /// A rule that indicates whether users that the post author mentions can reply to the post.
        ///
        /// - Note: According to the AT Protocol specifications: "Allow replies from actors mentioned
        /// in your post."
        public struct MentionRule: Sendable, Codable {}

        /// A rule that indicates whether users that the post author is following can reply to the post.
        ///
        /// - Note: According to the AT Protocol specifications: "Allow replies from actors you follow."
        public struct FollowingRule: Sendable, Codable {}

        /// A rule that indicates whether users that are on a specific list made by the post author can
        /// reply to the post.
        ///
        /// - Note: According to the AT Protocol specifications: "Allow replies from actors on a list."
        public struct ListRule: Sendable, Codable {

            /// The list itself.
            public let list: String
        }
    }
}
