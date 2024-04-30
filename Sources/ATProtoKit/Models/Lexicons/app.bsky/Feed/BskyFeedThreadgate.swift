//
//  BskyFeedThreadgate.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-06.
//

import Foundation

/// The main data model definition for a threadgate record.
///
/// - Note: According to the AT Protocol specifications: "Record defining interaction gating rules
/// for a thread (aka, reply controls). The record key (rkey) of the threadgate record must match
/// the record key of the thread's root post, and that record must be in the same repository."
///
/// - SeeAlso: This is based on the [`app.bsky.feed.threadgate`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/threadgate.json
public struct FeedThreadgate: ATRecordProtocol {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public static private(set) var type: String = "app.bsky.feed.threadgate"
    /// The URI of a post record.
    public let post: String
    public let allow: [ThreadgateUnion]
    @DateFormatting public var createdAt: Date

    public init(post: String, allow: [ThreadgateUnion], createdAt: Date) {
        self.post = post
        self.allow = allow
        self._createdAt = DateFormatting(wrappedValue: createdAt)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.post = try container.decode(String.self, forKey: .post)
        self.allow = try container.decode([ThreadgateUnion].self, forKey: .allow)
        self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

//        try container.encode(self.type, forKey: .type)
        try container.encode(self.post, forKey: .post)
        try container.encode(self.allow, forKey: .allow)
        try container.encode(self._createdAt, forKey: .createdAt)
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case post
        case allow
        case createdAt
    }
}

/// A rule that indicates whether users that the post author mentions can reply to the post.
///
/// - Note: According to the AT Protocol specifications: "Allow replies from actors mentioned
/// in your post."
public struct FeedThreadgateMentionRule: Codable {}

/// A rule that indicates whether users that the post author is following can reply to the post.
///
/// - Note: According to the AT Protocol specifications: "Allow replies from actors you follow."
public struct FeedThreadgateFollowingRule: Codable {}

/// A rule that indicates whether users that are on a specific list made by the post author can
/// reply to the post.
///
/// - Note: According to the AT Protocol specifications: "Allow replies from actors on a list."
public struct FeedThreadgateListRule: Codable {
    public let list: String
}


/// A reference containing the list of thread rules for a post.
public enum ThreadgateUnion: Codable {
    case mentionRule(FeedThreadgateMentionRule)
    case followingRule(FeedThreadgateFollowingRule)
    case listRule(FeedThreadgateListRule)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(FeedThreadgateMentionRule.self) {
            self = .mentionRule(value)
        } else if let value = try? container.decode(FeedThreadgateFollowingRule.self) {
            self = .followingRule(value)
        } else if let value = try? container.decode(FeedThreadgateListRule.self) {
            self = .listRule(value)
        } else {
            throw DecodingError.typeMismatch(
                EmbedViewUnion.self, DecodingError.Context(
                    codingPath: decoder.codingPath, debugDescription: "Unknown ThreadgateUnion type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .mentionRule(let embedView):
                try container.encode(embedView)
            case .followingRule(let embedView):
                try container.encode(embedView)
            case .listRule(let embedView):
                try container.encode(embedView)
        }
    }
}
