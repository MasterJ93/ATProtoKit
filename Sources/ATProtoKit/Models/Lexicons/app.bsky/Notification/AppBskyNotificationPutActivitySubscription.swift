//
//  AppBskyNotificationPutActivitySubscription.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-06-27.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Notification {

    /// A request body model for adding an activity subscription entry.
    ///
    /// - Note: According to the AT Protocol specifications: "Puts an activity subscription entry. The key
    /// should be omitted for creation and provided for updates. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.putActivitySubscription`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/putActivitySubscription.json
    public struct PutActivitySubscriptionRequestBody: Sendable, Codable {

        /// The decentralized identifier (DID) of the user account being subscribed to.
        public let subjectDID: String

        /// The activity subscription of the specificed user account.
        public let activitySubscription: ActivitySubscriptionDefinition

        enum CodingKeys: String, CodingKey {
            case subjectDID = "subject"
            case activitySubscription
        }
    }

    /// An output model for adding an activity subscription entry.
    ///
    /// - Note: According to the AT Protocol specifications: "Puts an activity subscription entry. The key
    /// should be omitted for creation and provided for updates. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.putActivitySubscription`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/putActivitySubscription.json
    public struct PutActivitySubscriptionOutput: Sendable, Codable {

        /// The decentralized identifier (DID) of the user account being subscribed to.
        public let subjectDID: String

        /// The activity subscription of the specificed user account. Optional.
        public let activitySubscription: ActivitySubscriptionDefinition?

        enum CodingKeys: String, CodingKey {
            case subjectDID = "subject"
            case activitySubscription
        }
    }
}
