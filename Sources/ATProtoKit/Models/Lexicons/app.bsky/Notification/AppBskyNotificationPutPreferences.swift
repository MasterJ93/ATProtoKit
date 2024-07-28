//
//  AppBskyNotificationPutPreferences.swift
//  
//
//  Created by Christopher Jr Riley on 2024-07-28.
//

import Foundation

extension AppBskyLexicon.Notification {

    /// A request body model for setting notification-related preferences for a user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Set notification-related
    /// preferences for an account. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.putPreferences`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/putPreferences.json
    public struct PutNotificationRequestBody: Codable {
        
        /// Indicates whether the priority preference is enabled.
        public let isPriority: Bool

        enum CodingKeys: String, CodingKey {
            case isPriority = "priority"
        }
    }
}
