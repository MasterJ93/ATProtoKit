//
//  ComAtprotoAdminUpdateAccountPassword.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Admin {

    /// A request body model for updating the handle of a user account as an administrator.
    ///
    /// - Note: According to the AT Protocol specifications: "Update the password for a
    /// user account as an administrator."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.updateAccountPassword`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/updateAccountPassword.json
    public struct UpdateAccountPasswordRequestBody: Codable {

        /// The decentralized identifier (DID) of the account.
        public let accountDID: String

        /// The new password for the user account.
        public let newPassword: String

        enum CodingKeys: String, CodingKey {
            case accountDID = "did"
            case newPassword = "password"
        }
    }
}
