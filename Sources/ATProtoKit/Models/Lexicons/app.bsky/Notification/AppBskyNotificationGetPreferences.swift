//
//  AppBskyNotificationGetPreferences.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-06-14.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Notification {

    /// An output model for getting notification preferences for a user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Get notification-related preferences for
    /// an account. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.getPreferences`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/getPreferences.json
    public struct GetPreferencesOutput: Sendable, Codable {

        /// A list of preferences.
        public let preferences: AppBskyLexicon.Notification.PreferencesDefinition
    }
}
