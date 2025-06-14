//
//  AppBskyNotificationPutPreferencesV2.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-06-14.
//

import Foundation

extension AppBskyLexicon.Notification {

    /// A request body model for setting notification preferences for a user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Set notification-related preferences for
    /// an account. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.putPreferencesV2`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/putPreferencesV2.json
    public struct PutPreferencesV2RequestBody: Sendable, Codable {

        /// A list of preferences for notifications related to chat conversations. Optional.
        public let chat: ChatPreferenceDefinition?

        /// A list of preferences for notifications related to follows. Optional.
        public let follow: FilterablePreferenceDefinition?

        /// A list of preferences for notifications related to likes. Optional.
        public let like: FilterablePreferenceDefinition?

        /// A list of preferences for notifications related to likes via reposts. Optional.
        public let likeViaRepost: FilterablePreferenceDefinition?

        /// A list of preferences for notifications related to mentions. Optional.
        public let mention: FilterablePreferenceDefinition?

        /// A list of preferences for notifications related to quote posts. Optional.
        public let quote: FilterablePreferenceDefinition?

        /// A list of preferences for notifications related to replies. Optional.
        public let reply: FilterablePreferenceDefinition?

        /// A list of preferences for notifications related to reposts. Optional.
        public let repost: FilterablePreferenceDefinition?

        /// A list of preferences for notifications related to reposts via reposts. Optional.
        public let repostViaRepost: FilterablePreferenceDefinition?

        /// A list of preferences for notifications related to joining a starter pack. Optional.
        public let starterPackJoined: PreferenceDefinition?

        /// A list of preferences for notifications related to post subscriptions. Optional.
        public let subscribedPost: PreferenceDefinition?

        /// A list of preferences for notifications related to getting unverified. Optional.
        public let unverified: PreferenceDefinition?

        /// A list of preferences for notifications related to getting verified. Optional.
        public let verified: PreferenceDefinition?
    }

    /// An output model for setting notification preferences for a user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Set notification-related preferences for
    /// an account. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.putPreferencesV2`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/putPreferencesV2.json
    public struct PutPreferencesV2Output: Sendable, Codable {

        /// A list of preferences.
        public let preferences: AppBskyLexicon.Notification.PreferencesDefinition
    }
}
