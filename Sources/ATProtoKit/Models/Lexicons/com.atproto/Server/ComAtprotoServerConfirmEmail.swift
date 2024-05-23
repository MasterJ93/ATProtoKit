//
//  ComAtprotoServerConfirmEmail.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// A request body model for confirming emails.
    ///
    /// - Note: According to the AT Protocol specifications: "Confirm an email using a token from com.atproto.server.requestEmailConfirmation."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.confirmEmail`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/confirmEmail.json
    public struct ConfirmEmailRequestBody: Codable {

        /// The email of the user.
        public let email: String

        /// The token given to the user via email.
        public let token: String
    }
}
