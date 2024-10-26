//
//  ComAtprotoAdminGetInviteCodes.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Admin {

    /// The main data model for getting the invite codes from a user account.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.getInviteCodes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/getInviteCodes.json
    public struct GetInviteCodes: Sendable, Codable {

        /// Sorts the invite codes by a particular order.
        public enum Sort {

            /// Sorts the invite codes by the most recently made.
            case recent

            /// Sorts the invite codes by the number of times it's been used.
            case usage
        }
    }

    /// An output model for getting the invite codes from a user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Get an admin view of invite codes."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.getInviteCodes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/getInviteCodes.json
    public struct GetInviteCodesOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of invite codes.
        public let codes: [ComAtprotoLexicon.Server.InviteCodeDefinition]
    }
}
