//
//  ComAtprotoServerCreateSession.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// A definition model for creating a session.
    ///
    /// - Note: According to the AT Protocol specifications: "Get information about the current
    /// auth session. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.getSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/getSession.json
    public struct CreateSession: Sendable, Encodable {

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

    /// A request body model for creating a session.
    ///
    /// - Note: According to the AT Protocol specifications: "Create an authentication session."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createSession.json
    public struct CreateSessionRequestBody: Sendable, Encodable {

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

    /// An output model for creating a session.
    ///
    /// - Note: According to the AT Protocol specifications: "Create an authentication session."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createSession.json
    public struct CreateSessionOutput: Sendable, Decodable {

        /// The access token of the session.
        public let accessToken: String

        /// The refresh token of the session.
        public let refreshToken: String

        /// The handle associated with the user account.
        public let handle: String

        /// The decentralized identifier (NSID) of the user account.
        public let did: String

        /// The DID document of the session. Optional.
        public let didDocument: UnknownType?

        /// The email associated with the user account. Optional.
        public let email: String?

        /// Indicates whether the user account has their email confirmed. Optional.
        public let isEmailConfirmed: Bool?

        /// Indicates whether multi-factor authentication is enabled in the user account. Optional.
        public let isEmailAuthenticatedFactor: Bool?

        /// Indicates whether the user account is active. Optional.
        public let isActive: Bool?

        /// Indicates the possible reason for why the user account is inactive. Optional.
        public let status: CreateSession.UserAccountStatus


        enum CodingKeys: String, CodingKey {
            case accessToken = "accessJwt"
            case refreshToken = "refreshJwt"
            case handle
            case did
            case didDocument = "didDoc"
            case email
            case isEmailConfirmed = "emailConfirmed"
            case isEmailAuthenticatedFactor = "emailAuthFactor"
            case isActive = "active"
            case status
        }
    }
}
