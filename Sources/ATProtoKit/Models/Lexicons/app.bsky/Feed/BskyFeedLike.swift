//
//  BskyFeedLike.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-08.
//

import Foundation

public struct FeedLike: Codable {
    public let type: String = "app.bsky.feed.like"
    public let recordURI: String
    public let cidHash: String
    @DateFormatting public var createdAt: Date

    public init(recordURI: String, cidHash: String, createdAt: Date) {
        self.recordURI = recordURI
        self.cidHash = cidHash
        self._createdAt = DateFormatting(wrappedValue: createdAt)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.recordURI = try container.decode(String.self, forKey: .recordURI)
        self.cidHash = try container.decode(String.self, forKey: .cidHash)
        self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.type, forKey: .type)
        try container.encode(self.recordURI, forKey: .recordURI)
        try container.encode(self.cidHash, forKey: .cidHash)
        try container.encode(self._createdAt, forKey: .createdAt)
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case recordURI = "uri"
        case cidHash = "cid"
        case createdAt
    }
}
