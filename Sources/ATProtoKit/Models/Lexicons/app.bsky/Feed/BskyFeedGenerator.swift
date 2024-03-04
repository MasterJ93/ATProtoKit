//
//  BskyFeedGenerator.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-04.
//

import Foundation

/// The main data model definition for a feed generator record.
///
/// - Note: According to the AT Protocol specifications: "Record declaring of the existence of a feed generator, and containing metadata about it. The record can exist in any repository."
///
/// - SeeAlso: This is based on the [`app.bsky.feed.generator`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/generator.json
public struct FeedGenerator: Codable {
    /// The decentralized identifier (DID) of the feed.
    public let feedDID: String
    /// The display name of the feed.
    ///
    /// - Important: Current maximum lenth is 24 characters. This library will automatically truncate the `String` to the maximum length if it does go over the limit.
    public let displayName: String
    /// The description of the feed. Optional.
    ///
    /// - Important: Current maximum lenth is 300 characters. This library will automatically truncate the `String` to the maximum length if it does go over the limit.
    public let description: String?
    /// An array of the facets within the feed generator's description. Optional.
    public let descriptionFacets: [Facet]?
    /// The URL of the avatar image. Optional.
    public let avatarImageURL: URL?
    /// An array of labels created by the user. Optional.
    public let labels: [SelfLabels]?
    /// The date and time the feed was created.
    @DateFormatting public var createdAt: Date

    public init(feedDID: String, displayName: String, description: String?, descriptionFacets: [Facet]?, avatarImageURL: URL?,
                labels: [SelfLabels]?, createdAt: Date) {
        self.feedDID = feedDID
        self.displayName = displayName
        self.description = description
        self.descriptionFacets = descriptionFacets
        self.avatarImageURL = avatarImageURL
        self.labels = labels
        self._createdAt = DateFormatting(wrappedValue: createdAt)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.feedDID = try container.decode(String.self, forKey: .feedDID)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.descriptionFacets = try container.decodeIfPresent([Facet].self, forKey: .descriptionFacets)
        self.avatarImageURL = try container.decodeIfPresent(URL.self, forKey: .avatarImageURL)
        self.labels = try container.decodeIfPresent([SelfLabels].self, forKey: .labels)
        self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.feedDID, forKey: .feedDID)
        // Truncate `displayName` to 240 characters before encoding
        // `maxGraphemes`'s limit is 24, but `String.count` should respect that limit implictly
        try truncatedEncode(self.displayName, withContainer: &container, forKey: .description, upToLength: 240)
        // Truncate `displayName` to 3,000 characters before encoding
        // `maxGraphemes`'s limit is 300, but `String.count` should respect that limit implictly
        try truncatedEncodeIfPresent(self.description, withContainer: &container, forKey: .description, upToLength: 3_000)
        try container.encodeIfPresent(self.descriptionFacets, forKey: .descriptionFacets)
        try container.encodeIfPresent(self.avatarImageURL, forKey: .avatarImageURL)
        try container.encodeIfPresent(self.labels, forKey: .labels)
        try container.encode(self._createdAt, forKey: .createdAt)
    }

    enum CodingKeys: String, CodingKey {
        case feedDID = "did"
        case displayName
        case description
        case descriptionFacets
        case avatarImageURL = "avatar"
        case labels
        case createdAt
    }
}
