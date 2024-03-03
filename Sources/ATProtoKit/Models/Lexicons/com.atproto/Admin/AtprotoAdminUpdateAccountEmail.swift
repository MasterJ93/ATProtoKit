//
//  AtprotoAdminUpdateAccountEmail.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-02.
//

import Foundation

/// The main data model definition for updating the email address of a user account as an administrator.
///
/// - Note: According to the AT Protocol specifications: "Administrative action to update an account's email."
///
/// - SeeAlso: This is based on the [`com.atproto.admin.updateAccountEmail`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/updateAccountEmail.json
public struct AdminUpdateAccountEmail: Codable {
    /// The decentralized identifier (DID) of the account.
    public let accountDID: String
    /// The new email account the user wants to change to.
    public let accountEmail: String

    enum CodingKeys: String, CodingKey {
        case accountDID = "account"
        case accountEmail = "email"
    }
}
