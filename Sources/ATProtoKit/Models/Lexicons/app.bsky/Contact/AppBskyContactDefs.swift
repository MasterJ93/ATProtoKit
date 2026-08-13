//
//  AppBskyContactDefs.swift
//  ATProtoKit
//
//  Created by KC-2001MS on 2026-08-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Contact {

    /// A definition model for a matched contact and its index.
    ///
    /// - Note: According to the AT Protocol specifications: "Associates a profile with the
    /// positional index of the contact import input in the call to
    /// `app.bsky.contact.importContacts`, so clients can know which phone caused a
    /// particular match."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/defs.json
    public struct MatchAndContactIndexDefinition: Sendable, Codable {

        /// The profile of the matched user.
        public let match: AppBskyLexicon.Actor.ProfileViewDefinition

        /// The index of this match in the import contact input.
        public let contactIndex: Int
    }

    /// A definition model for a contact sync status.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/defs.json
    public struct SyncStatusDefinition: Sendable, Codable {

        /// The last date and time when contacts were imported.
        public let syncedAt: Date

        /// The number of existing contact matches.
        ///
        /// - Note: According to the AT Protocol specifications: "Number of existing contact
        /// matches resulting of the user imports and of their imported contacts having imported
        /// the user. Matches stop being counted when the user either follows the matched contact
        /// or dismisses the match."
        public let matchesCount: Int

        public init(syncedAt: Date, matchesCount: Int) {
            self.syncedAt = syncedAt
            self.matchesCount = matchesCount
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.syncedAt = try container.decodeDate(forKey: .syncedAt)
            self.matchesCount = try container.decode(Int.self, forKey: .matchesCount)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeDate(self.syncedAt, forKey: .syncedAt)
            try container.encode(self.matchesCount, forKey: .matchesCount)
        }

        enum CodingKeys: CodingKey {
            case syncedAt
            case matchesCount
        }
    }

    /// A definition model for a contact import notification.
    ///
    /// - Note: According to the AT Protocol specifications: "A stash object to be sent via bsync
    /// representing a notification to be created."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/defs.json
    public struct NotificationDefinition: Sendable, Codable {

        /// The decentralized identifier (DID) of the sender of the notification.
        public let fromDID: String

        /// The decentralized identifier (DID) of the recipient of the notification.
        public let toDID: String

        enum CodingKeys: String, CodingKey {
            case fromDID = "from"
            case toDID = "to"
        }
    }
}
