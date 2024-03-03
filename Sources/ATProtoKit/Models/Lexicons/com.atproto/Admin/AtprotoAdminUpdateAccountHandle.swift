//
//  AtprotoAdminUpdateAccountHandle.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-03.
//

import Foundation

/// The main data model definition for updating the handle of a user account as an administrator.
///
/// - Note: According to the AT Protocol specifications: "Administrative action to update an account's handle."
///
/// - SeeAlso: This is based on the [`com.atproto.admin.updateAccountHandle`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/updateAccountHandle.json
public struct AdminUpdateAccountHandle: Codable {
    public let accountDID: String
    public let accountHandle: String

    enum CodingKeys: String, CodingKey {
        case accountDID = "did"
        case accountHandle = "handle"
    }
}
