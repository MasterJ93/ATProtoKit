//
//  BskyNotificationGetUnreadCount.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-15.
//

import Foundation

/// The main data model definition for the output of counting the unread notifications.
///
/// - Note: According to the AT Protocol specifications: "Count the number of unread
/// notifications for the requesting account. Requires auth."
///
/// - SeeAlso: This is based on the [`app.bsky.notification.getUnreadCount`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/getUnreadCount.json
public struct NotificationGetUnreadCountOutput: Codable {
    public let count: Int
}
