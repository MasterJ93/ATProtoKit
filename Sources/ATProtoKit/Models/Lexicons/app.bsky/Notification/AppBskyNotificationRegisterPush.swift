//
//  AppBskyNotificationRegisterPush.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Notification {


    /// The main data model definition for registering push notifications.
    public struct RegisterPush: Codable {

        /// Represents the platform for the push notifications.
        public enum Platform: String, Codable {

            /// Indicates iOS as the platform.
            case ios

            /// Indicates Android as the platform.
            case android

            /// Indicates the web as the platform.
            case web
        }
    }

    /// A request body model for registering push notifications.
    ///
    /// - Note: According to the AT Protocol specifications: "Register to receive
    /// push notifications, via a specified service, for the requesting account.
    /// Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.registerPush`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/registerPush.json
    public struct RegisterPushRequestBody: Codable {

        /// The decentralized identifier (DID) for the push notification request.
        public let serviceDID: String

        /// The push notification token.
        public let token: String

        /// The platform for the push notifications.
        public let platform: RegisterPush.Platform

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
