//
//  ComAtprotoAdminGetAccountInfos.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Admin {

    /// An output model for retrieving an array of user accounts.
    ///
    /// - Note: According to the AT Protocol specifications: "Get details about some accounts."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.getAccountInfos`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/getAccountInfos.json
    public struct GetAccountInfosOutput: Sendable, Codable {

        /// An array of user account information.
        public let infos: [AccountViewDefinition]
    }
}
