//
//  ToolsOzoneSignatureFindRelatedAccounts.swift
//
//
//  Created by Christopher Jr Riley on 2024-10-24.
//

import Foundation

extension ToolsOzoneLexicon.Signature {

    /// A definition model for getting user accounts that match threat signatures with the root
    /// user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Get accounts that share some matching
    /// threat signatures with the root account."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.signature.findRelatedAccounts`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/signature/findRelatedAccounts.json
    public struct FindRelatedAccounts: Sendable, Codable {

        /// A definition model for related accounts.
        public struct RelatedAccounts: Sendable, Codable {

            /// An array of account views.
            public let accounts: [ComAtprotoLexicon.Admin.AccountViewDefinition]

            /// An array of similarities. Optional.
            public let similarities: [ToolsOzoneLexicon.Signature.SignatureDetailDefinition]?
        }
    }

    /// An output model for getting user accounts that match threat signatures with the root
    /// user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Get accounts that share some matching
    /// threat signatures with the root account."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.signature.findRelatedAccounts`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/signature/findRelatedAccounts.json
    public struct FindRelatedAccountsOutput: Sendable, Codable {

        /// The related user accounts that match the threat signature with the root user account.
        public let relatedAccounts: ToolsOzoneLexicon.Signature.FindRelatedAccounts.RelatedAccounts
    }
}
