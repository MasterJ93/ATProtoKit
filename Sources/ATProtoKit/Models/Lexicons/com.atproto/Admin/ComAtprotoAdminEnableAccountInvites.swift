//
//  ComAtprotoAdminEnableAccountInvites.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Admin {

    /// The main data model definition for giving the user account access to receive invite
    /// codes again.
    ///
    /// - Note: According to the AT Protocol specifications: "Re-enable an account's ability to
    /// receive invite codes."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.enableAccountInvites`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/enableAccountInvites.json
    public struct EnableAccountInvitesRequestBody: Codable {

        /// The decentralized identifier (DID) of the account that will regain access to receiving
        /// invite codes.
        public let accountDID: String

        /// A note as to why this action is being done. Optional.
        public let note: String?

        enum CodingKeys: String, CodingKey {
            case accountDID = "account"
            case note
        }
    }
}
