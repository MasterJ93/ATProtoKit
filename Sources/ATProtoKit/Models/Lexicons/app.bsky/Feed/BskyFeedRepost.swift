//
//  BskyFeedRepost.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-06.
//

import Foundation

/// The main data model definition for a repost record on Bluesky.
///
/// - Note: According to the AT Protocol specifications: "Record representing a 'repost' of an existing Bluesky post."
///
/// - SeeAlso: This is based on the [`app.bsky.feed.repost`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/repost.json
public struct FeedRepost: ATRecordProtocol {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public private(set) var type: String = "app.bsky.feed.repost"
    /// The strong reference of the repost record.
    public let subject: StrongReference
    /// The date the like record was created.
    ///
    /// This is the date where the user "liked" a post.
    @DateFormatting public var createdAt: Date

    public init(subject: StrongReference, createdAt: Date) {
        self.subject = subject
        self._createdAt = DateFormatting(wrappedValue: createdAt)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.subject = try container.decode(StrongReference.self, forKey: .subject)
        self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.subject, forKey: .subject)
        try container.encode(self._createdAt, forKey: .createdAt)
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case subject
        case createdAt
    }
}
