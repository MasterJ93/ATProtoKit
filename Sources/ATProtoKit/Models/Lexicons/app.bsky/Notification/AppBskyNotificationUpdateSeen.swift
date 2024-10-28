//
//  AppBskyNotificationUpdateSeen.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Notification {

    /// A request body model for updating the server of the user seeing the notification.
    ///
    /// - Note: According to the AT Protocol specifications: "Notify server that the requesting
    /// account has seen notifications. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.updateSeen`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/updateSeen.json
    public struct UpdateSeenRequestBody: Sendable, Codable {

        /// The date and time the notification was seen by the user account.
        @DateFormatting public var seenAt: Date

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self._seenAt, forKey: .seenAt)
        }

        enum CodingKeys: CodingKey {
            case seenAt
        }
    }
}
