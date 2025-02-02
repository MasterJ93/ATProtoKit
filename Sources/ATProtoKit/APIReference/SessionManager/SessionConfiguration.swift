//
//  SessionConfiguration.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation
import Logging

/// Defines the requirements for session configurations within ATProtoKit.
public protocol SessionConfiguration: Sendable {

    /// The user's handle within the AT Protocol.
    var handle: String { get }

    /// The password associated with the user's account, used for authentication.
    var password: String { get }

    /// The decentralized identifier (DID), serving as a persistent and long-term account
    /// identifier according to the W3C standard.
    var sessionDID: String { get }

    /// The user's email address. Optional.
    var email: String? { get }

    /// Indicates whether the user's email address has been confirmed. Optional.
    var isEmailConfirmed: Bool? { get }

    /// Indicates whether Two-Factor Authentication (via email) is enabled. Optional.
    var isEmailAuthenticationFactorEnabled: Bool? { get }

    /// The access token used for API requests that requests authentication.
    var accessToken: String { get }

    /// The refresh token used to generate a new access token.
    var refreshToken: String { get }

    /// The DID document associated with the user, which contains AT Protocol-specific
    /// information. Optional.
    var didDocument: DIDDocument? { get }

    /// Indicates whether the user account is active. Optional.
    var isActive: Bool? { get }

    /// Indicates the possible reason for why the user account is inactive. Optional.
    var status: UserAccountStatus? { get }

    /// The user account's endpoint used for sending authentication requests.
    var serviceEndpoint: URL { get }

    /// The base URL of the Personal Data Server (PDS) with which the AT Protocol interacts.
    ///
    /// This URL is used to make network requests to the PDS for various operations, such as
    /// session creation, refresh, and deletion.
    var pdsURL: String { get }

    /// Specifies the logger that will be used for emitting log messages. Optional.
    ///
    /// - Note: This is not included when initalizing `UserSession`. Instead, it's added
    /// after the successful initalizing.
    var logger: Logger? { get }

    /// The object attached to the configuration class that holds the session. Optional.
    ///
    /// This also includes things such as retry limits and logging.
    var session: UserSession? { get }

    /// The number of times a request can be attempted before it's considered a failure.
    ///
    /// By default, ATProtoKit will retry a request attempt for 1 second.
    ///
    /// - Note: This is not included when initalizing `UserSession`. Instead, it's added
    /// after the successful initalizing.
    var maxRetryCount: Int? { get }

    /// The length of time to wait before attempting to retry a request.
    ///
    /// By default, ATProtoKit will wait for 1 second before attempting to retry a request.
    /// ATProtoKit will change the number exponentally in order to help prevent overloading
    /// the server.
    ///
    /// - Note: This is not included when initalizing `UserSession`. Instead, it's added
    /// after the successful initalizing.
    var retryTimeDelay: TimeInterval? { get }


    /// Attempts to authenticate with the PDS using the `handle` and `appPassword`.
    ///
    /// This method should implement the necessary logic to authenticate the user against the PDS,
    /// returning a `UserSession` object upon successful authentication or an error if
    /// authentication fails. If the account has Two-Factor Authentication enabled, this must be
    /// handled as well.
    ///
    /// - Parameter authenticationFactorToken: A token used for
    /// Two-Factor Authentication. Optional.
    ///
    /// - Throws: An error if there are issues creating the request or communicating with the PDS.
    func authenticate(authenticationFactorToken: String?) async throws
}
