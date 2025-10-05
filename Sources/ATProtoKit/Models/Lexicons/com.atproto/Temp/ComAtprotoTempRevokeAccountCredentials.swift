//
//  ComAtprotoTempRevokeAccountCredentials.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-09-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Temp {

    /// A request body for revoking sessions, the account password, and app passwords associated with the
    /// account, which may be resolved by a password reset.
    ///
    /// - Note: According to the AT Protocol specifications: "Revoke sessions, password, and app passwords
    /// associated with account. May be resolved by a password reset."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.temp.revokeAccountCredentials`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/temp/revokeAccountCredentials.json
    public struct RevokeAccountCredentialsRequestBody: Sendable, Codable {

        /// The AT Identifier of the user account to revoke their credentials for.
        public let account: String
    }
}
