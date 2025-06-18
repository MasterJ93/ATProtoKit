//
//  ComAtprotoAdminUpdateAccountHandle.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Admin {

    /// A request body model for updating the handle of a user account as an administrator.
    ///
    /// - Note: According to the AT Protocol specifications: "Administrative action to update
    /// an account's handle."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.updateAccountHandle`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/updateAccountHandle.json
    public struct UpdateAccountHandleRequestBody: Sendable, Codable {

        /// The decentralized identifier (DID) of the account.
        public let accountDID: String

        /// The new account handle the user wants to change to.
        public let accountHandle: String

        enum CodingKeys: String, CodingKey {
            case accountDID = "did"
            case accountHandle = "handle"
        }
    }
}
