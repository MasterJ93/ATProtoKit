//
//  AppBskyNotificationDefs.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-14.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Notification {

    /// A definition model for a deleted record.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/defs.json
    public struct RecordDeletedDefinition: Sendable, Codable {}

    /// A definition model for chat preferences.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/defs.json
    public struct ChatPreferenceDefinition: Sendable, Codable {

        /// A filter of what conversations to get push notifications for.
        public let filter: Filter

        /// Determines whether push notifications for chat messages.
        public let willPush: Bool

        enum CodingKeys: String, CodingKey {
            case filter
            case willPush = "push"
        }

        // Enums
        /// A filter of what conversations to get push notifications for.
        public enum Filter: Sendable, Codable, ExpressibleByStringLiteral {

            /// Display all conversations.
            case all

            /// Only display any conversations that have been accepted by the user account.
            case accepted

            /// An unknown value that the object may contain.
            case unknown(String)

            public var rawValue: String {
                switch self {
                    case .all:
                        return "all"
                    case .accepted:
                        return "accepted"
                    case .unknown(let value):
                        return value
                }
            }

            public init(stringLiteral value: String) {
                self = .unknown(value)
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let value = try container.decode(String.self)

                switch value {
                    case "all":
                        self = .all
                    case "accepted":
                        self = .accepted
                    default:
                        self = .unknown(value)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encode(self.rawValue)
            }
        }
    }

    /// A definition model for filtered chat preferences.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/defs.json
    public struct FilterablePreferenceDefinition: Sendable, Codable {

        /// A filter of what conversations to get push notifications for.
        public let filter: Filter

        /// Determines whether the notification will appear in the notification list.
        public let willAppearInNotificationList: Bool

        /// Determines whether push notifications for chat messages.
        public let willPush: Bool

        enum CodingKeys: String, CodingKey {
            case filter
            case willAppearInNotificationList = "list"
            case willPush = "push"
        }

        // Enums
        /// A filter of what conversations to get push notifications for.
        public enum Filter: Sendable, Codable, ExpressibleByStringLiteral {

            /// Display all conversations.
            case all

            /// Only display any conversations that have been accepted by the user account.
            case accepted

            /// An unknown value that the object may contain.
            case unknown(String)

            public var rawValue: String {
                switch self {
                    case .all:
                        return "all"
                    case .accepted:
                        return "accepted"
                    case .unknown(let value):
                        return value
                }
            }

            public init(stringLiteral value: String) {
                self = .unknown(value)
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let value = try container.decode(String.self)

                switch value {
                    case "all":
                        self = .all
                    case "accepted":
                        self = .accepted
                    default:
                        self = .unknown(value)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encode(self.rawValue)
            }
        }
    }

    /// A definition model for a preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/defs.json
    public struct PreferenceDefinition: Sendable, Codable {

        /// Determines whether the notification will appear in the notification list.
        public let willAppearInNotificationList: Bool

        /// Determines whether push notifications for chat messages.
        public let willPush: Bool

        enum CodingKeys: String, CodingKey {
            case willAppearInNotificationList = "list"
            case willPush = "push"
        }

        // Enums
        /// A filter of what conversations to get push notifications for.
        public enum Filter: Sendable, Codable, ExpressibleByStringLiteral {

            /// Display all conversations.
            case all

            /// Only display any conversations that have been accepted by the user account.
            case accepted

            /// An unknown value that the object may contain.
            case unknown(String)

            public var rawValue: String {
                switch self {
                    case .all:
                        return "all"
                    case .accepted:
                        return "accepted"
                    case .unknown(let value):
                        return value
                }
            }

            public init(stringLiteral value: String) {
                self = .unknown(value)
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let value = try container.decode(String.self)

                switch value {
                    case "all":
                        self = .all
                    case "accepted":
                        self = .accepted
                    default:
                        self = .unknown(value)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encode(self.rawValue)
            }
        }
    }

    /// A definition model for preferences.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/defs.json
    public struct PreferencesDefinition: Sendable, Codable {

        /// A list of preferences for notifications related to chat conversations.
        public let chat: ChatPreferenceDefinition

        /// A list of preferences for notifications related to follows.
        public let follow: FilterablePreferenceDefinition

        /// A list of preferences for notifications related to likes.
        public let like: FilterablePreferenceDefinition

        /// A list of preferences for notifications related to likes via reposts.
        public let likeViaRepost: FilterablePreferenceDefinition

        /// A list of preferences for notifications related to mentions.
        public let mention: FilterablePreferenceDefinition

        /// A list of preferences for notifications related to quote posts.
        public let quote: FilterablePreferenceDefinition

        /// A list of preferences for notifications related to replies.
        public let reply: FilterablePreferenceDefinition

        /// A list of preferences for notifications related to reposts.
        public let repost: FilterablePreferenceDefinition

        /// A list of preferences for notifications related to reposts via reposts.
        public let repostViaRepost: FilterablePreferenceDefinition

        /// A list of preferences for notifications related to joining a starter pack.
        public let starterPackJoined: PreferenceDefinition

        /// A list of preferences for notifications related to post subscriptions.
        public let subscribedPost: PreferenceDefinition

        /// A list of preferences for notifications related to getting unverified.
        public let unverified: PreferenceDefinition

        /// A list of preferences for notifications related to getting verified.
        public let verified: PreferenceDefinition
    }
}
