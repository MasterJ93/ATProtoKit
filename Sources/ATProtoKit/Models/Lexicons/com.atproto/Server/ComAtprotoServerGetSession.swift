//
//  ComAtprotoServerGetSession.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-03.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// A definition model for getting session information from the user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Get information about the current
    /// auth session. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.getSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/getSession.json
    public struct GetSession: Sendable, Codable {

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

    /// An output model for getting session information from the user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Get information about the current
    /// auth session. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.getSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/getSession.json
    public struct GetSessionOutput: Sendable, Codable {

        /// The user account's handle.
        public let handle: String

        /// The decentralized identifier (NSID) of the session.
        public let did: String

        /// The email connected to the user account. Optional.
        public let email: String?

        /// Indicates whether the user account has their email confirmed. Optional.
        public let isEmailConfirmed: Bool?

        /// Indicates whether multi-factor authentication is enabled in the user account. Optional.
        public let isEmailAuthenticationFactor: Bool?

        /// The DID document associated with the user, which contains AT Protocol-specific
        /// information. Optional.
        public let didDocument: UnknownType?

        /// Indicates whether the user account is active. Optional.
        public let isActive: Bool?

        /// Indicates the possible reason for why the user account is inactive. Optional.
        public let status: GetSession.UserAccountStatus?

        enum CodingKeys: String, CodingKey {
            case handle
            case did
            case email
            case isEmailConfirmed = "emailConfirmed"
            case isEmailAuthenticationFactor = "emailAuthFactor"
            case didDocument = "didDoc"
            case isActive = "active"
            case status
        }
    }
}
