//
//  ComAtprotoAdminUpdateAccountSigningKey.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-03-31.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Admin {

    /// A request body model for updating an account's signing key in their DID document as
    /// an administrator.
    ///
    /// - Note: According to the AT Protocol specifications: "Administrative action to update an
    /// account's signing key in their Did document."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.updateAccountSigningKey`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/updateAccountSigningKey.json
    public struct UpdateAccountSigningKeyRequestBody: Sendable, Codable {

        /// The decentralized identifier (DID) of the account.
        public let did: String

        /// The public key, formatted as the DID Key.
        ///
        /// - Note: According to the AT Protocol specifications: "Did-key formatted public key"
        public let signingKey: String
    }
}
