//
//  AppBskyFeedThreadgate.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Feed {

    /// A record model for a threadgate.
    ///
    /// - Important: When creating this record, be sure that the record key of a
    /// ``AppBskyLexicon/Feed/PostRecord`` is the same as the record key of this record. 
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

        /// An array of rules used as an allowlist. Optional.
        ///
        /// - Important: Current maximum length is 5 items.
        public let allow: [ThreadgateUnion]?

        /// The date and time of the creation of the threadgate.
        public let createdAt: Date

        /// An array of hidden replies in the form of URIs. Optional.
        ///
        /// - Important: Current maximum length is 50 items.
        ///
        /// - Note: According to the AT Protocol specifications: "List of hidden reply URIs."
        public let hiddenReplies: [String]?

        public init(postURI: String, allow: [ThreadgateUnion]?, createdAt: Date, hiddenReplies: [String]?) {
            self.postURI = postURI
            self.allow = allow
            self.createdAt = createdAt
            self.hiddenReplies = hiddenReplies
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.postURI = try container.decode(String.self, forKey: .postURI)
            self.allow = try container.decodeIfPresent([ThreadgateUnion].self, forKey: .allow)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
            self.hiddenReplies = try container.decodeIfPresent([String].self, forKey: .hiddenReplies)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.postURI, forKey: .postURI)
            try container.truncatedEncodeIfPresent(self.allow, forKey: .allow, upToArrayLength: 5)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
            try container.truncatedEncodeIfPresent(self.hiddenReplies, forKey: .hiddenReplies, upToArrayLength: 300)
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
        public struct MentionRule: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the object.
            public let type = "app.bsky.feed.threadgate#mentionRule"

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }

        /// A rule that allows users who follow you to reply to the user account's post.
        ///
        /// - Note: According to the AT Protocol specifications: "Allow replies from actors who
        /// follow you."
        public struct FollowerRule: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the object.
            public let type = "app.bsky.feed.threadgate#followerRule"

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }

        /// A rule that allows users that are followed by the user account to reply to the post.
        ///
        /// - Note: According to the AT Protocol specifications: "Allow replies from actors you follow."
        public struct FollowingRule: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the object.
            public let type = "app.bsky.feed.threadgate#followingRule"

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }

        /// A rule that allows users are in a specified list to reply to the post.
        ///
        /// - Note: According to the AT Protocol specifications: "Allow replies from actors on a list."
        public struct ListRule: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the object.
            public let type = "app.bsky.feed.threadgate#listRule"

            /// The list itself.
            public let listURI: String

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case listURI = "list"
            }
        }

        // Unions
        /// An array of rules used as an allowlist.
        public enum ThreadgateUnion: ATUnionProtocol, Equatable, Hashable {

            /// A rule that allows users that were mentioned in the user account's post to reply to
            /// said post.
            case mentionRule(AppBskyLexicon.Feed.ThreadgateRecord.MentionRule)

            /// A rule that allows users who follow you to reply to the user account's post.
            case followerRule(AppBskyLexicon.Feed.ThreadgateRecord.FollowerRule)

            /// A rule that allows users that are followed by the user account to reply to the post.
            case followingRule(AppBskyLexicon.Feed.ThreadgateRecord.FollowingRule)

            /// A rule that allows users are in a specified list to reply to the post.
            case listRule(AppBskyLexicon.Feed.ThreadgateRecord.ListRule)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "app.bsky.feed.threadgate#mentionRule":
                        self = .mentionRule(try AppBskyLexicon.Feed.ThreadgateRecord.MentionRule(from: decoder))
                    case "app.bsky.feed.threadgate#followerRule":
                        self = .followerRule(try AppBskyLexicon.Feed.ThreadgateRecord.FollowerRule(from: decoder))
                    case "app.bsky.feed.threadgate#followingRule":
                        self = .followingRule(try AppBskyLexicon.Feed.ThreadgateRecord.FollowingRule(from: decoder))
                    case "app.bsky.feed.threadgate#listRule":
                        self = .listRule(try AppBskyLexicon.Feed.ThreadgateRecord.ListRule(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                switch self {
                    case .mentionRule(let embedView):
                        try container.encode("app.bsky.feed.threadgate#mentionRule", forKey: .type)
                        try embedView.encode(to: encoder)
                    case .followerRule(let embedView):
                        try container.encode("app.bsky.feed.threadgate#followerRule", forKey: .type)
                        try embedView.encode(to: encoder)
                    case .followingRule(let embedView):
                        try container.encode("app.bsky.feed.threadgate#followingRule", forKey: .type)
                        try embedView.encode(to: encoder)
                    case .listRule(let embedView):
                        try container.encode("app.bsky.feed.threadgate#listRule", forKey: .type)
                        try embedView.encode(to: encoder)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }
    }
}
