//
//  ComAtprotoServerRevokeAppPassword.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// A request body model for revoking a password.
    ///
    /// - Note: According to the AT Protocol specifications: "Revoke an App Password by name."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.revokeAppPassword`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/revokeAppPassword.json
    public struct RevokeAppPasswordRequestBody: Sendable, Codable {

        /// The name associated with the App Password.
        public let appPasswordName: String

        enum CodingKeys: String, CodingKey {
            case appPasswordName = "name"
        }
    }
}
