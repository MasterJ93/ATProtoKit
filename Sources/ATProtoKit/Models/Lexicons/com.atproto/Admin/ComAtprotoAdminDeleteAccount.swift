//
//  ComAtprotoAdminDeleteAccount.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Admin {

    /// A request body model for deleting a user's account as an administrator.
    ///
    /// - Note: According to the AT Protocol specifications: "Delete a user account as
    /// an administrator."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.deleteAccount`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/deleteAccount.json
    public struct DeleteAccountRequestBody: Sendable, Codable {

        /// The decentralized identifier (DID) of the account to be deleted.
        public let accountDID: String
    }
}
