//
//  AtprotoServerRequestPasswordReset.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-26.
//

import Foundation

/// The main data model definition for resetting the user's password.
///
/// - Note: According to the AT Protocol specifications: "Initiate a user account password reset via email."
///
/// - SeeAlso: This is based on the [`com.atproto.server.requestPasswordReset`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/requestPasswordReset.json
public struct ServerRequestPasswordReset: Codable {
    /// The email address associated with the user's account.
    public let email: String
}
