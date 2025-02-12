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
    public struct ThreadgateRecord: ATRecordProtocol, Sendable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.feed.threadgate"

        /// The URI of a post record.
        ///
        /// - Note: According to the AT Protocol specifications: "Reference (AT-URI) to the
        /// post record."
        public let postURI: String

        /// An array of rules used as an allowlist.
        ///
        /// - Important: Current maximum length is 5 items.
        public let allow: [ATUnion.ThreadgateUnion]?

        /// The date and time of the creation of the threadgate.
        public let createdAt: Date

        /// An array of hidden replies in the form of URIs. Optional.
        ///
        /// - Important: Current maximum length is 50 items.
        ///
        /// - Note: According to the AT Protocol specifications: "List of hidden reply URIs."
        public let hiddenReplies: [String]?

        public init(postURI: String, allow: [ATUnion.ThreadgateUnion]?, createdAt: Date, hiddenReplies: [String]?) {
            self.postURI = postURI
            self.allow = allow
            self.createdAt = createdAt
            self.hiddenReplies = hiddenReplies
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.postURI = try container.decode(String.self, forKey: .postURI)
            self.allow = try container.decodeIfPresent([ATUnion.ThreadgateUnion].self, forKey: .allow)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
            self.hiddenReplies = try container.decodeIfPresent([String].self, forKey: .hiddenReplies)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.postURI, forKey: .postURI)
            try container.encodeIfPresent(self.allow, forKey: .allow)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
            try container.truncatedEncodeIfPresent(self.hiddenReplies, forKey: .hiddenReplies, upToArrayLength: 50)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case postURI = "post"
            case allow
            case createdAt
            case hiddenReplies
        }

        /// A rule that allows users that were mentioned in the user account's post to reply to
        /// said post.
        ///
        /// - Note: According to the AT Protocol specifications: "Allow replies from actors mentioned
        /// in your post."
        public struct MentionRule: Sendable, Codable, Equatable, Hashable {}

        /// A rule that allows users who follow you to reply to the user account's post.
        ///
        /// - Note: According to the AT Protocol specifications: "Allow replies from actors who
        /// follow you."
        public struct FollowerRule: Sendable, Codable, Equatable, Hashable {}

        /// A rule that allows users that are followed by the user account to reply to the post.
        ///
        /// - Note: According to the AT Protocol specifications: "Allow replies from actors you follow."
        public struct FollowingRule: Sendable, Codable, Equatable, Hashable {}

        /// A rule that allows users are in a specified list to reply to the post.
        ///
        /// - Note: According to the AT Protocol specifications: "Allow replies from actors on a list."
        public struct ListRule: Sendable, Codable, Equatable, Hashable {

            /// The list itself.
            public let list: String
        }
    }
}
