//
//  BskyFeedLike.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-08.
//

import Foundation

public struct FeedLike: Codable {
    public let type: String = "app.bsky.feed.like"
    public let subject: StrongReference
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
        case recordURI = "uri"
        case cidHash = "cid"
        case subject
        case createdAt
    }
}
