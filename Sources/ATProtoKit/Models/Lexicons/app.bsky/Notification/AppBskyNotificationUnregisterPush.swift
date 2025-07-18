//
//  AppBskyNotificationUnregisterPush.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-07-15.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Notification {

    /// The main data model definition for unregistering push notifications.
    public struct UnregisterPush: Sendable, Codable {

        /// Represents the platform for the push notifications.
        public enum Platform: String, Sendable, Codable {

            /// Indicates iOS as the platform.
            case ios

            /// Indicates Android as the platform.
            case android

            /// Indicates the web as the platform.
            case web
        }
    }

    /// A request body model for unregistering push notifications.
    ///
    /// - Note: According to the AT Protocol specifications: "The inverse of registerPush - inform a
    /// specified service that push notifications should no longer be sent to the given token for the
    /// requesting account. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.unregisterPush`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/unregisterPush.json
    public struct UnregisterPushRequestBody: Sendable, Codable {

        /// The decentralized identifier (DID) for the push notification request.
        public let serviceDID: String

        /// The push notification token.
        public let token: String

        /// The platform for the push notifications.
        public let platform: UnregisterPush.Platform

        /// The app ID for the push notification.
        public let appID: String

        enum CodingKeys: String, CodingKey {
            case serviceDID = "serviceDid"
            case token
            case platform
            case appID = "appId"
        }
    }
}
