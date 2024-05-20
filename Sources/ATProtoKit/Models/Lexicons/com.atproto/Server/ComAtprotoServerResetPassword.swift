//
//  ComAtprotoServerResetPassword.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// The main data model definition for resetting a password.
    ///
    /// - Note: According to the AT Protocol specifications: "Reset a user account password using a token."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.resetPassword`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/resetPassword.json
    public struct ResetPasswordRequestBody: Codable {

        /// The token used to reset the password.
        public let token: String

        /// The new password for the user's account.
        public let newPassword: String

        enum CodingKeys: String, CodingKey {
            case token
            case newPassword = "password"
        }
    }
}
