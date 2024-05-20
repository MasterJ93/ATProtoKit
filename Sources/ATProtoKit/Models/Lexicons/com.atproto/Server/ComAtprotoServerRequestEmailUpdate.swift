//
//  ComAtprotoServerRequestEmailUpdate.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// A data model definition for the output of requesting to update the user's email address.
    ///
    /// - Note: According to the AT Protocol specifications: "Request a token in order to
    /// update email."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.requestEmailUpdate`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/requestEmailUpdate.json
    public struct RequestEmailUpdateOutput: Codable {

        /// Indicates whether a token is required.
        public let isTokenRequired: Bool

        enum CodingKeys: String, CodingKey {
            case isTokenRequired = "tokenRequired"
        }
    }
}
