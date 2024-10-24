//
//  ToolsOzoneSignatureSearchAccounts.swift
//
//
//  Created by Christopher Jr Riley on 2024-10-24.
//

import Foundation

extension ToolsOzoneLexicon.Signature {

    /// An output model for searching user accounts that match one or more threat signature values.
    ///
    /// - Note: According to the AT Protocol specifications: "Search for accounts that match one or
    /// more threat signature values."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.signature.searchAccounts`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/signature/searchAccounts.json
    public struct SearchAccountsOutput: Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of accounts.
        public let accounts: [ComAtprotoLexicon.Admin.AccountViewDefinition]
    }
}
