//
//  AppBskyNotificationListNotifications.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Notification {

    /// An output model for listing notifications.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerate notifications for the
    /// requesting account. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.listNotifications`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/listNotifications.json
    public struct ListNotificationsOutput: Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of notifications.
        public let notifications: [Notification]
    }

    /// A data model definition for a notification.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.listNotifications`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/listNotifications.json
    public struct Notification: Codable {

        /// The URI of the notification.
        public let notificationURI: String

        /// The CID hash of the notification.
        public let notificationCID: String

        /// The author of the record contained in the notification.
        public let notificationAuthor: String

        /// The kind of notification received.
        ///
        /// - Note: According to the AT Protocol specifications: "Expected values are 'like',
        /// 'repost', 'follow', 'mention', 'reply', and 'quote'."
        public let notificationReason: Reason

        /// The URI of the subject in the notification. Optional.
        public let reasonSubjectURI: String?

        /// The record itself that's attached to the notification.
        public let record: UnknownType

        /// Indicates whether or not this notification was read.
        public let isRead: Bool

        /// The date and time the notification was last indexed.
        @DateFormatting public var indexedAt: Date

        /// An array of labels. Optional.
        public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        public init(notificationURI: String, notificationCID: String, notificationAuthor: String, notificationReason: Reason, reasonSubjectURI: String,
                    record: UnknownType, isRead: Bool, indexedAt: Date, labels: [ComAtprotoLexicon.Label.LabelDefinition]) {
            self.notificationURI = notificationURI
            self.notificationCID = notificationCID
            self.notificationAuthor = notificationAuthor
            self.notificationReason = notificationReason
            self.reasonSubjectURI = reasonSubjectURI
            self.record = record
            self.isRead = isRead
            self._indexedAt = DateFormatting(wrappedValue: indexedAt)
            self.labels = labels
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.notificationURI = try container.decode(String.self, forKey: .notificationURI)
            self.notificationCID = try container.decode(String.self, forKey: .notificationCID)
            self.notificationAuthor = try container.decode(String.self, forKey: .notificationAuthor)
            self.notificationReason = try container.decode(Notification.Reason.self, forKey: .notificationReason)
            self.reasonSubjectURI = try container.decodeIfPresent(String.self, forKey: .reasonSubjectURI)
            self.record = try container.decode(UnknownType.self, forKey: .record)
            self.isRead = try container.decode(Bool.self, forKey: .isRead)
            self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
            self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: .labels)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.notificationURI, forKey: .notificationURI)
            try container.encode(self.notificationCID, forKey: .notificationCID)
            try container.encode(self.notificationAuthor, forKey: .notificationAuthor)
            try container.encode(self.notificationReason, forKey: .notificationReason)
            try container.encodeIfPresent(self.reasonSubjectURI, forKey: .reasonSubjectURI)
            try container.encode(self.record, forKey: .record)
            try container.encode(self.isRead, forKey: .isRead)
            try container.encode(self._indexedAt, forKey: .indexedAt)
            try container.encodeIfPresent(self.labels, forKey: .labels)
        }

        enum CodingKeys: String, CodingKey {
            case notificationURI = "uri"
            case notificationCID = "cid"
            case notificationAuthor = "author"
            case notificationReason = "reason"
            case reasonSubjectURI = "reasonSubject"
            case record
            case isRead
            case indexedAt
            case labels
        }

        // Enums
        /// The kind of notification received.
        public enum Reason: String, Codable {

            /// Indicates the notification is about someone liking a post from the user account.
            case like

            /// Indicates the notification is about someone reposting a post from the
            /// user account.
            case repost

            /// Indicates the notification is about someone following the user account.
            case follow

            /// Indicates the notification is about someone @mentioning the user account.
            case mention

            /// Indicates the notification is about someone replying to one of the
            /// user account's posts.
            case reply

            /// Indicates the notification is about someone quoting a post from the user account.
            case quote
        }
    }
}
