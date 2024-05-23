//
//  ComAtprotoServerUpdateEmail.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// A request body model for updating the user's email address.
    ///
    /// - Note: According to the AT Protocol specifications: "Update an account's email."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.updateEmail`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/updateEmail.json
    public struct UpdateEmailRequestBody: Codable {

        /// The email associated with the user's account.
        public let email: String

        /// Indicates whether Two-Factor Authentication (via email) is enabled. Optional.
        public let isEmailAuthenticationFactorEnabled: Bool?

        /// The token that's used if the email has been confirmed. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Requires a token from com.atproto.sever.requestEmailUpdate if the account's email has
        /// been confirmed."
        public let token: String?

        enum CodingKeys: String, CodingKey {
            case email
            case isEmailAuthenticationFactorEnabled = "emailAuthFactor"
            case token
        }
    }
}
