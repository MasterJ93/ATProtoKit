//
//  AppBskyUnspeccedDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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

        // Enums
        /// The status of the topic.
        public enum Status: String, Sendable, Codable {

            /// The topic is hot.
            case hot
        }
    }

    /// A definition model for an age assurance state.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "The computed state of the age assurance
    /// process, returned to the user in question on certain authenticated requests."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/defs.json
    public struct AgeAssuranceStateDefinition: Sendable, Codable {

        /// The date and time the state was last updated.
        ///
        /// - Note: According to the AT Protocol specifications: "The timestamp when this state was
        /// last updated."
        public let lastInitiatedAt: Date?

        /// The current status of the age assurance process.
        ///
        /// - Note: According to the AT Protocol specifications: "The status of the age assurance process."
        public let status: Status

        public init(lastInitiatedAt: Date?, status: Status) {
            self.lastInitiatedAt = lastInitiatedAt
            self.status = status
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: AppBskyLexicon.Unspecced.AgeAssuranceStateDefinition.CodingKeys.self)

            self.lastInitiatedAt = try container.decodeDateIfPresent(forKey: .lastInitiatedAt)
            self.status = try container.decode(Status.self, forKey: .status)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(self.lastInitiatedAt, forKey: .lastInitiatedAt)
            try container.encode(self.status, forKey: .status)
        }

        enum CodingKeys: CodingKey {
            case lastInitiatedAt
            case status
        }

        // Enums
        public enum Status: Sendable, Codable, ExpressibleByStringLiteral {

            /// The status is unknown.
            case unknown

            /// The status is pending.
            case pending

            /// The status is assured.
            case assured

            /// The status is blocked.
            case blocked

            /// A custom string value that the object may contain.
            case customString(String)

            /// Provides the raw string value for encoding, decoding, and comparison.
            public var rawValue: String {
                switch self {
                    case .unknown:
                        return "unknown"
                    case .pending:
                        return "pending"
                    case .assured:
                        return "assured"
                    case .blocked:
                        return "blocked"
                    case .customString(let value):
                        return value
                }
            }

            public init(stringLiteral value: String) {
                self = .customString(value)
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let value = try container.decode(String.self)

                switch value {
                    case "unknown":
                        self = .unknown
                    case "pending":
                        self = .pending
                    case "assured":
                        self = .assured
                    case "blocked":
                        self = .blocked
                    default:
                        self = .customString(value)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encode(self.rawValue)
            }
        }
    }

    /// A definition model for an object used to store age assurance data.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Object used to store age assurance data
    /// in stash."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/defs.json
    public struct AgeAssuranceEventDefinition: Sendable, Codable {

        /// The date and time the age assurance flow completed.
        ///
        /// - Note: According to the AT Protocol specifications: "The date and time of this
        /// write operation."
        public let createdAt: Date

        /// The age assurance flow's status.
        ///
        /// - Note: According to the AT Protocol specifications: "The status of the age assurance process."
        public let status: Status

        /// A UUID-formatted identifier of the age assurance attempt.
        ///
        /// - Note: According to the AT Protocol specifications: "The unique identifier for this instance of
        /// the age assurance flow, in UUID format."
        public let attemptID: String

        /// The email address associated with the age assurance process. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "he email used for AA."
        public let email: String?

        /// The IP address used when the age assurance flow began. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The IP address used when initiating the
        /// AA flow."
        public let initialIPAddress: String?

        /// The user agent used when the age assurance flow began. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The user agent used when initiating the
        /// AA flow."
        public let initialUserAgent: String?

        /// The IP address used when the age assurance flow completed. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The IP address used when completing the
        /// AA flow"
        public let completedIPAddress: String?

        /// The user agent used when the age assurance flow completed. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The user agent used when completing the
        /// AA flow."
        public let completedUserAgent: String?

        public init(createdAt: Date, status: Status, attemptID: String, email: String?, initialIPAddress: String?, initialUserAgent: String?,
                    completedIPAddress: String?, completedUserAgent: String?) {
            self.createdAt = createdAt
            self.status = status
            self.attemptID = attemptID
            self.email = email
            self.initialIPAddress = initialIPAddress
            self.initialUserAgent = initialUserAgent
            self.completedIPAddress = completedIPAddress
            self.completedUserAgent = completedUserAgent
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.createdAt = try container.decodeDate(forKey: .createdAt)
            self.status = try container.decode(Status.self, forKey: .status)
            self.attemptID = try container.decode(String.self, forKey: .attemptID)
            self.email = try container.decodeIfPresent(String.self, forKey: .email)
            self.initialIPAddress = try container.decodeIfPresent(String.self, forKey: .initialIPAddress)
            self.initialUserAgent = try container.decodeIfPresent(String.self, forKey: .initialUserAgent)
            self.completedIPAddress = try container.decodeIfPresent(String.self, forKey: .completedIPAddress)
            self.completedUserAgent = try container.decodeIfPresent(String.self, forKey: .completedUserAgent)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeDate(self.createdAt, forKey: .createdAt)
            try container.encode(self.status, forKey: .status)
            try container.encode(self.attemptID, forKey: .attemptID)
            try container.encodeIfPresent(self.email, forKey: .email)
            try container.encodeIfPresent(self.initialIPAddress, forKey: .initialIPAddress)
            try container.encodeIfPresent(self.initialUserAgent, forKey: .initialUserAgent)
            try container.encodeIfPresent(self.completedIPAddress, forKey: .completedIPAddress)
            try container.encodeIfPresent(self.completedUserAgent, forKey: .completedUserAgent)
        }

        enum CodingKeys: String, CodingKey {
            case createdAt
            case status
            case attemptID = "attemptId"
            case email
            case initialIPAddress = "initIp"
            case initialUserAgent = "initUa"
            case completedIPAddress = "completeIp"
            case completedUserAgent = "completeUa"
        }

        // Enums
        /// The age assurance flow's status.
        public enum Status: Sendable, Codable, ExpressibleByStringLiteral {

            /// The status is unknown.
            case unknown

            /// The status is pending.
            case pending

            /// The status is assured.
            case assured

            /// A custom string value the object may contain.
            case customString(String)

            /// Provides the raw string value for encoding, decoding, and comparison.
            public var rawValue: String {
                switch self {
                    case .unknown:
                        return "unknown"
                    case .pending:
                        return "pending"
                    case .assured:
                        return "assured"
                    case .customString(let value):
                        return value
                }
            }

            public init(stringLiteral value: String) {
                self = .customString(value)
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let value = try container.decode(String.self)

                switch value {
                    case "unknown":
                        self = .unknown
                    case "pending":
                        self = .pending
                    case "assured":
                        self = .assured
                    default:
                        self = .customString(value)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encode(self.rawValue)
            }
        }
    }
}
