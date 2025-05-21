//
//  AppBskyUnspeccedDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Unspecced {

    /// A definition model for a skeleton post in a search context.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/defs.json
    public struct SkeletonSearchPostDefinition: Sendable, Codable {

        /// The URI of the skeleton post.
        public let postURI: String

        enum CodingKeys: String, CodingKey {
            case postURI = "uri"
        }
    }

    /// A definition model for a skeleton post in a search context.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/defs.json
    public struct SkeletonSearchActorDefinition: Sendable, Codable {

        /// The URI of the skeleton actor.
        public let did: String

        enum CodingKeys: String, CodingKey {
            case did
        }
    }

    /// A definition model for a skeleton starter pack in a search context.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/defs.json
    public struct SkeletonSearchStarterPackDefinition: Sendable, Codable {

        /// The URI of the skeleton starter pack.
        public let uri: String
    }

    /// A definition model for a trending topic.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/defs.json
    public struct TrendingTopicDefinition: Sendable, Codable {

        /// The topic itself.
        public let topic: String

        /// The display name of the topic. Optional.
        public let displayName: String?

        /// A description about the topic. Optional.
        public let description: String?

        /// The link the trending topic is located.
        public let link: String
    }

    /// A definition model for a skeleton trend.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/defs.json
    public struct SkeletonTrendDefinition: Sendable, Codable {

        ///
        public let topic: String

        /// The display name of the topic.
        public let displayName: String

        /// The URL of the topic.
        public let link: String

        /// The date and time the topic began to start trending.
        public let startedAt: Date

        /// The number of posts in the topic.
        public let postCount: Int

        /// The status of the topic. Optional.
        public let status: Status?

        /// The topic's category. Optional.
        public let category: String?

        /// An array of decentralized identifiers (DIDs) related to the topic.
        public let dids: [String]

        public init(topic: String, displayName: String, link: String, startedAt: Date, postCount: Int, status: Status?, category: String?, dids: [String]) {
            self.topic = topic
            self.displayName = displayName
            self.link = link
            self.startedAt = startedAt
            self.postCount = postCount
            self.status = status
            self.category = category
            self.dids = dids
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.topic = try container.decode(String.self, forKey: .topic)
            self.displayName = try container.decode(String.self, forKey: .displayName)
            self.link = try container.decode(String.self, forKey: .link)
            self.startedAt = try container.decodeDate(forKey: .startedAt)
            self.postCount = try container.decode(Int.self, forKey: .postCount)
            self.status = try container.decodeIfPresent(AppBskyLexicon.Unspecced.SkeletonTrendDefinition.Status.self, forKey: .status)
            self.category = try container.decodeIfPresent(String.self, forKey: .category)
            self.dids = try container.decode([String].self, forKey: .dids)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.topic, forKey: .topic)
            try container.encode(self.displayName, forKey: .displayName)
            try container.encode(self.link, forKey: .link)
            try container.encodeDate(self.startedAt, forKey: .startedAt)
            try container.encode(self.postCount, forKey: .postCount)
            try container.encodeIfPresent(self.status, forKey: .status)
            try container.encodeIfPresent(self.category, forKey: .category)
            try container.encode(self.dids, forKey: .dids)
        }

        enum CodingKeys: CodingKey {
            case topic
            case displayName
            case link
            case startedAt
            case postCount
            case status
            case category
            case dids
        }

        // Enums
        /// The status of the topic.
        public enum Status: String, Sendable, Codable {

            /// The topic is hot.
            case hot
        }
    }

    /// A definition model for a trend view.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/defs.json
    public struct TrendViewDefinition: Sendable, Codable {

        /// A shorthand, lowercased version of the topic name.
        public let topic: String

        /// The display name of the topic.
        public let displayName: String

        /// The URL of the topic.
        public let link: String

        /// The date and time the topic began to start trending.
        public let startedAt: Date

        /// The number of posts in the topic.
        public let postCount: Int

        /// The status of the topic. Optional.
        public let status: Status?

        /// The topic's category. Optional.
        public let category: String?

        /// An array of profiles related to the topic.
        public let actors: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]

        public init(topic: String, displayName: String, link: String, startedAt: Date, postCount: Int, status: Status?, category: String?,
            actors: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]) {
            self.topic = topic
            self.displayName = displayName
            self.link = link
            self.startedAt = startedAt
            self.postCount = postCount
            self.status = status
            self.category = category
            self.actors = actors
        }

        enum CodingKeys: CodingKey {
            case topic
            case displayName
            case link
            case startedAt
            case postCount
            case status
            case category
            case actors
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.topic = try container.decode(String.self, forKey: .topic)
            self.displayName = try container.decode(String.self, forKey: .displayName)
            self.link = try container.decode(String.self, forKey: .link)
            self.startedAt = try container.decodeDate(forKey: .startedAt)
            self.postCount = try container.decode(Int.self, forKey: .postCount)
            self.status = try container.decodeIfPresent(AppBskyLexicon.Unspecced.TrendViewDefinition.Status.self, forKey: .status)
            self.category = try container.decodeIfPresent(String.self, forKey: .category)
            self.actors = try container.decode([AppBskyLexicon.Actor.ProfileViewBasicDefinition].self, forKey: .actors)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.topic, forKey: .topic)
            try container.encode(self.displayName, forKey: .displayName)
            try container.encode(self.link, forKey: .link)
            try container.encodeDate(self.startedAt, forKey: .startedAt)
            try container.encode(self.postCount, forKey: .postCount)
            try container.encodeIfPresent(self.status, forKey: .status)
            try container.encodeIfPresent(self.category, forKey: .category)
            try container.encode(self.actors, forKey: .actors)
        }

        // Enums
        /// The status of the topic.
        public enum Status: String, Sendable, Codable {

            /// The topic is hot.
            case hot
        }
    }
}
