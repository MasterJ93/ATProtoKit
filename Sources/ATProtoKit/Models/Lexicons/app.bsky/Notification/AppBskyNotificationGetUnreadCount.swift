//
//  AppBskyNotificationGetUnreadCount.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Notification {

    /// An output model for counting the unread notifications.
    ///
    /// - Note: According to the AT Protocol specifications: "Count the number of unread
    /// notifications for the requesting account. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.getUnreadCount`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/getUnreadCount.json
    public struct GetUnreadCountOutput: Sendable, Codable {

        /// The number of unread notifications.
        public let count: Int
    }
}
