//
//  AppBskyNotificationListActivitySubscriptions.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-06-27.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Notification {

    /// An output model for listing all user accounts that the authenticated user account is subscribed to
    /// receive notifications for.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerate all accounts to which the requesting
    /// account is subscribed to receive notifications for. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.listActivitySubscriptions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/listActivitySubscriptions.json
    public struct ListActivitySubscriptionsOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of profile views belonging to user account's that the authenticated user account
        /// is subscribed to.
        public let subscriptions: [AppBskyLexicon.Actor.ProfileViewDefinition]

    }
}
