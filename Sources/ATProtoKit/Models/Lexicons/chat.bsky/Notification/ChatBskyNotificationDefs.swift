//
//  ChatBskyNotificationDefs.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-12.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Notification {

    /// A definition model for a chat notification preference entry.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.notification.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/notification/defs.json
    public struct ChatPreferenceDefinition: Sendable, Codable {

        /// A filter of which conversations trigger push notifications.
        public let include: Include

        /// Determines whether push notifications for chat messages are enabled.
        public let willPush: Bool

        enum CodingKeys: String, CodingKey {
            case include
            case willPush = "push"
        }

        // Enums
        /// A filter of which conversations trigger push notifications.
        public enum Include: Sendable, Codable, ExpressibleByStringLiteral {

            /// Include notifications from all conversations.
            case all

            /// Include notifications only from accounts the user follows.
            case follows

            /// An unknown value that the object may contain.
            case unknown(String)

            public var rawValue: String {
                switch self {
                    case .all:
                        return "all"
                    case .follows:
                        return "follows"
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
                    case "follows":
                        self = .follows
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

    /// A definition model for the full set of chat notification preferences.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.notification.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/notification/defs.json
    public struct PreferencesDefinition: Sendable, Codable {

        /// Notification preferences for accepted conversations.
        public let chat: ChatPreferenceDefinition

        /// Notification preferences for conversation requests.
        public let chatRequest: ChatPreferenceDefinition
    }
}
