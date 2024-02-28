//
//  AtprotoAdminDisableAccountInvites.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-28.
//

import Foundation

/// The main data model definition for disabling a user account's ability to receive new invite codes.
///
/// - Note: According to the AT Protocol specifications: "Disable an account from receiving new invite codes, but does not invalidate existing codes."
///
/// - SeeAlso: This is based on the [`com.atproto.admin.disableAccountInvites`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/disableAccountInvites.json
public struct AdminDisableAccountInvites: Codable {
    /// The decentralized identifier (DID) of the user account.
    public let accountDID: String
    /// A comment explaining why the user won't receive new account invites. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Optional reason for disabled invites."
    public let note: String?

    enum CodingKeys: String, CodingKey {
        case accountDID = "account"
        case note
    }
}
