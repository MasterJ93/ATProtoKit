//
//  ComAtprotoAdminDisableInviteCodes.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Admin {

    /// A request body model for disabling some or all of the invite codes for one or more
    /// user accounts.
    ///
    /// - Note: According to the AT Protocol specifications: "Disable some set of codes and/or all
    /// codes associated with a set of users."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.disableInviteCodes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/disableInviteCodes.json
    public struct DisableInviteCodesRequestBody: Sendable, Codable {

        /// The invite codes to disable.
        public let codes: [String]

        /// The decentralized identifiers (DIDs) of the user accounts.
        public let accountDIDs: [String]

        enum CodingKeys: String, CodingKey {
            case codes
            case accountDIDs = "accounts"
        }
    }
}
