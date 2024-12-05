//
//  ComAtprotoServerRefreshSession.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-04.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// A definition model for refreshing a session.
    ///
    /// - Note: According to the AT Protocol specifications: "Get information about the current
    /// auth session. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.getSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/getSession.json
    public struct RefreshSession: Sendable, Codable {

        /// Indicates the status of the user account if it's inactivate.
        ///
        /// - Note: According to the AT Protocol specifications: "If active=false, this optional
        /// field indicates a possible reason for why the account is not active. If active=false
        /// and no status is supplied, then the host makes no claim for why the repository is no
        /// longer being hosted."
        public enum UserAccountStatus: String, Sendable, Codable {

            /// Indicates the user account is inactive due to a takedown.
            case takedown

            /// Indicates the user account is inactivate due to a suspension.
            case suspended

            /// Indicates the user account is inactivate due to a deactivation.
            case deactivated
        }
    }

    /// An output model for refreshing a session.
    ///
    /// - Note: According to the AT Protocol specifications: "Refresh an authentication session.
    /// Requires auth using the 'refreshJwt' (not the 'accessJwt')."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.refreshSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/refreshSession.json
    public struct RefreshSessionOutput: Sendable, Codable {

        /// The access token of the session.
        public let accessToken: String

        /// The refresh token of the session.
        public let refreshToken: String

        /// The handle associated with the user account.
        public let handle: String

        /// The decentralized identifier (NSID) of the user account.
        public let did: String

        /// The DID document of the session. Optional.
        public let didDocument: String?

        /// Indicates whether the user account is active. Optional.
        public let isActive: Bool?

        /// Indicates the possible reason for why the user account is inactive. Optional.
        public let status: String?

        enum CodingKeys: String, CodingKey {
            case accessToken = "accessJwt"
            case refreshToken = "refreshJwt"
            case handle
            case did
            case didDocument = "didDoc"
            case isActive = "active"
            case status
        }
    }
}
