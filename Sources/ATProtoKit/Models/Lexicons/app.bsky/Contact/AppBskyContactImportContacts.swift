//
//  AppBskyContactImportContacts.swift
//  ATProtoKit
//
//  Created by KC-2001MS on 2026-08-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Contact {

    /// A request body model for importing contacts.
    ///
    /// - Note: According to the AT Protocol specifications: "Securely imports contacts to match
    /// with other users. Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.importContacts`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/importContacts.json
    public struct ImportContactsRequestBody: Sendable, Codable {

        /// The JWT token received from `app.bsky.contact.verifyPhone`.
        public let token: String

        /// An array of phone numbers in E.164 format to import.
        ///
        /// Can contain between 1 and 1,000 phone numbers.
        public let contacts: [String]

        public init(token: String, contacts: [String]) {
            self.token = token
            self.contacts = contacts
        }
    }

    /// An output model for importing contacts.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.importContacts`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/importContacts.json
    public struct ImportContactsOutput: Sendable, Codable {

        /// An array of matched users and their corresponding contact indexes.
        ///
        /// - Note: According to the AT Protocol specifications: "The users that matched during
        /// import and their indexes on the input contacts, so the client can correlate with its
        /// local list."
        public let matchesAndContactIndexes: [AppBskyLexicon.Contact.MatchAndContactIndexDefinition]
    }
}
