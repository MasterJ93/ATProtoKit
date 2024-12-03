//
//  SessionConfiguration.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation

/// Defines the requirements for session configurations within ATProtoKit.
public protocol SessionConfiguration {

    /// The user's unique handle used for authentication purposes.
    var handle: String { get }

    /// The app password associated with the user's account, used for authentication.
    var appPassword: String { get }

    /// The base URL of the Personal Data Server (PDS) with which the AT Protocol interacts.
    ///
    /// This URL is used to make network requests to the PDS for various operations, such as
    /// session creation, refresh, and deletion.
    var pdsURL: String { get }

    /// The object attached to the configuration class that holds the session. Optional.
    ///
    /// This also includes things such as retry limits and logging.
    var session: UserSession? { get }

    /// Attempts to authenticate with the PDS using the `handle` and `appPassword`.
    ///
    /// This method should implement the necessary logic to authenticate the user against the PDS,
    /// returning a `UserSession` object upon successful authentication or an error if
    /// authentication fails. If the account has Two-Factor Authentication enabled, this must be
    /// handled as well.
    ///
    /// - Parameter authenticationFactorToken: A token used for
    /// Two-Factor Authentication. Optional.
    /// - Returns: An instance of an authenticated user session within the AT Protocol. It may also
    /// have logging information, as well as the URL of the Personal Data Server (PDS).
    ///
    /// - Throws: An error if there are issues creating the request or communicating with the PDS.
    func authenticate(authenticationFactorToken: String?) async throws -> UserSession
}
