//
//  ComAtprotoServerActivateAccount.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// The request body data model definition for activating an account.
    ///
    /// - Note: According to the AT Protocol specifications: "Activates a currently deactivated
    /// account. Used to finalize account migration after the account's repo is imported and
    /// identity is setup."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.activateAccount`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/activateAccount.json
    public struct ActivateAccountRequestBody: Codable {}
}
