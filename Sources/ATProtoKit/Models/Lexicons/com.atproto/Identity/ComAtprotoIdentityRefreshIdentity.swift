//
//  ComAtprotoIdentityRefreshIdentity.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-26.
//

import Foundation

extension ComAtprotoLexicon.Identity {

    /// A request body model for requesting the server to re-resolve a
    /// decentralized identity (DID) and handle of a user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Request that the server re-resolve
    /// an identity (DID and handle). The server may ignore this request, or require
    /// authentication, depending on the role, implementation, and policy of the server."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.identity.refreshIdentity`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/refreshIdentity.json
    public struct RefreshIdentityRequestBody: Sendable, Codable {

        /// The AT-identifier of the user account.
        public let identifier: String
    }
}
