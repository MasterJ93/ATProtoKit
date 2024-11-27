//
//  ComAtprotoServerCreateSession.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// A request body model for creating a session.
    ///
    /// - Note: According to the AT Protocol specifications: "Create an authentication session."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createSession.json
    public struct CreateSessionRequestBody: Encodable {

        /// The indentifier of the user's account (typically a handle).
        ///
        /// - Note: According to the AT Protocol specifications: "Handle or other identifier
        /// supported by the server for the authenticating user."
        let identifier: String

        /// The App Password of the user's account.
        let password: String

        /// A token used for Two-Factor Authentication. Optional.
        let authenticationFactorToken: String?

        enum CodingKeys: String, CodingKey {
            case identifier
            case password
            case authenticationFactorToken = "authFactorToken"
        }
    }
}
