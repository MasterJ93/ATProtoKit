//
//  AppBskyNotificationDeclaration.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-06-27.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Notification {

    /// A record model for a notification declaration.
    ///
    /// - Note: According to the AT Protocol specifications: "A declaration of the user's choices related to
    /// notifications that can be produced by them."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.declaration`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/declaration.json
    public struct DeclarationRecord: ATRecordProtocol, Sendable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.notification.declaration"

        /// A setting that determines the group of user accounts that can subscribe to their activity.
        ///
        /// If this record doesn't exist in the user account's repository, the default will be `.followers`.
        ///
        /// - Note: According to the AT Protocol specifications: "A declaration of the user's preference for
        /// allowing activity subscriptions from other users. Absence of a record implies 'followers'."
        public let allowSubscriptions: AllowSubscriptions

        public init(allowSubscriptions: AllowSubscriptions) {
            self.allowSubscriptions = allowSubscriptions
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.allowSubscriptions = try container.decode(AllowSubscriptions.self, forKey: .allowSubscriptions)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(allowSubscriptions, forKey: .allowSubscriptions)
        }

        enum CodingKeys: CodingKey {
            case allowSubscriptions
        }

        // Enums
        /// A setting that determines the group of user accounts that can subscribe to their activity.
        public enum AllowSubscriptions: Sendable, Codable, Equatable, Hashable, ExpressibleByStringLiteral {

            /// Those who are following the user account can subscribe.
            case followers

            /// Those who are mutually following the user account can subscribe.
            case mutuals

            /// No one can subscribe.
            case none

            /// An unknown value that the object may contain.
            case unknown(String)

            /// Provides the raw string value for encoding, decoding, and comparison.
            public var rawValue: String {
                switch self {
                    case .followers:
                        return "followers"
                    case .mutuals:
                        return "mutuals"
                    case .none:
                        return "none"
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
                    case "followers":
                        self = .followers
                    case "mutuals":
                        self = .mutuals
                    case "none":
                        self = .none
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
}
