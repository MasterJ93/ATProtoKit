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
    public struct ListNotificationsOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of notifications.
        public let notifications: [Notification]

        /// Indicates whether the priority preference is enabled. Optional.
        public let isPriority: Bool?

        /// The date and time the notification was last seen. Optional.
        public let seenAt: Date?

        public init(cursor: String?, notifications: [Notification], isPriority: Bool?, seenAt: Date?) {
            self.cursor = cursor
            self.notifications = notifications
            self.isPriority = isPriority
            self.seenAt = seenAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
            self.notifications = try container.decode([AppBskyLexicon.Notification.Notification].self, forKey: .notifications)
            self.isPriority = try container.decodeIfPresent(Bool.self, forKey: .isPriority)
            self.seenAt = try container.decodeDateIfPresent(forKey: .seenAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(self.cursor, forKey: .cursor)
            try container.encode(self.notifications, forKey: .notifications)
            try container.encodeIfPresent(self.isPriority, forKey: .isPriority)
            try container.encodeDateIfPresent(self.seenAt, forKey: .seenAt)
        }

        enum CodingKeys: String, CodingKey {
            case cursor
            case notifications
            case isPriority = "priority"
            case seenAt
        }
    }

    /// A data model definition for a notification.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.listNotifications`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/listNotifications.json
    public struct Notification: Sendable, Codable {

        /// The URI of the notification.
        public let uri: String

        /// The CID hash of the notification.
        public let cid: String

        /// The author of the record contained in the notification.
        public let author: AppBskyLexicon.Actor.ProfileViewDefinition

        /// The kind of notification received.
        ///
        /// - Note: According to the AT Protocol specifications: "Expected values are 'like', 'repost',
        /// 'follow', 'mention', 'reply', 'quote', 'starterpack-joined', 'verified', and 'unverified'.
        public let reason: Reason

        /// The URI of the subject in the notification. Optional.
        public let reasonSubjectURI: String?

        /// The record that's attached to the notification.
        public let record: UnknownType

        /// Indicates whether or not this notification was read.
        public let isRead: Bool

        /// The date and time the notification was last indexed.
        public let indexedAt: Date

        /// An array of labels for the notication. Optional.
        public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        public init(uri: String, cid: String, author: AppBskyLexicon.Actor.ProfileViewDefinition, reason: Reason, reasonSubjectURI: String?,
                    record: UnknownType, isRead: Bool, indexedAt: Date, labels: [ComAtprotoLexicon.Label.LabelDefinition]?) {
            self.uri = uri
            self.cid = cid
            self.author = author
            self.reason = reason
            self.reasonSubjectURI = reasonSubjectURI
            self.record = record
            self.isRead = isRead
            self.indexedAt = indexedAt
            self.labels = labels
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.uri = try container.decode(String.self, forKey: .uri)
            self.cid = try container.decode(String.self, forKey: .cid)
            self.author = try container.decode(AppBskyLexicon.Actor.ProfileViewDefinition.self, forKey: .author)
            self.reason = try container.decode(AppBskyLexicon.Notification.Notification.Reason.self, forKey: .reason)
            self.reasonSubjectURI = try container.decodeIfPresent(String.self, forKey: .reasonSubjectURI)
            self.record = try container.decode(UnknownType.self, forKey: .record)
            self.isRead = try container.decode(Bool.self, forKey: .isRead)
            self.indexedAt = try container.decodeDate(forKey: .indexedAt)
            self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: .labels)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.uri, forKey: .uri)
            try container.encode(self.cid, forKey: .cid)
            try container.encode(self.author, forKey: .author)
            try container.encode(self.reason, forKey: .reason)
            try container.encodeIfPresent(self.reasonSubjectURI, forKey: .reasonSubjectURI)
            try container.encode(self.record, forKey: .record)
            try container.encode(self.isRead, forKey: .isRead)
            try container.encodeDate(self.indexedAt, forKey: .indexedAt)
            try container.encodeIfPresent(self.labels, forKey: .labels)
        }

        enum CodingKeys: String, CodingKey {
            case uri
            case cid
            case author
            case reason
            case reasonSubjectURI = "reasonSubject"
            case record
            case isRead
            case indexedAt
            case labels
        }

        // Enums
        /// The kind of notification received.
        public enum Reason: String, Sendable, Codable {

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

            /// Indicates the notification is about someone joining Bluesky using the
            /// user account's starter pack.
            case starterpackjoined = "starterpack-joined"

            /// Indicates the notification is about the user account getting verified.
            case verified

            /// Indicates the notification is about the user account getting unverified.
            case unverified
        }
    }
}
