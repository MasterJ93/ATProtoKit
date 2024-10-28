//
//  ComAtprotoAdminSearchAccounts.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-05.
//

import Foundation

extension ComAtprotoLexicon.Admin {

    /// An output model for listing accounts from a search query.
    ///
    /// - Note: According to the AT Protocol specifications: "Get list of accounts that matches
    /// your search query."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.searchAccounts`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/searchAccounts.json
    public struct SearchAccountsOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// A list of accounts from the search query.
        public let accounts: [ComAtprotoLexicon.Admin.AccountViewDefinition]
    }
}
