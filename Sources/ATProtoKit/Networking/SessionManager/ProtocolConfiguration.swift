//
//  ProtocolConfiguration.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation

/// Defines the requirements for protocol configurations within ATProtoKit.
public protocol ProtocolConfiguration {
    /// The user's unique handle used for authentication purposes.
    var handle: String { get }
    /// The app password associated with the user's account, used for authentication.
    var appPassword: String { get }
    /// The base URL of the Personal Data Server (PDS) with which the AT Protocol interacts.
    ///
    /// This URL is used to make network requests to the PDS for various operations, such as
    /// session creation, refresh, and deletion.
    var pdsURL: String { get }
    /// Attempts to authenticate with the PDS using the `handle` and `appPassword`.
    ///
    /// This method should implement the necessary logic to authenticate the user against the PDS,
    /// returning a `UserSession` object upon successful authentication or an error if authentication fails.
    ///
    /// - Returns: A `Result` type containing either a ``UserSession`` on success or an `Error` on failure.
    /// - Throws: An error if there are issues forming the request or communicating with the PDS.
    func authenticate() async throws -> Result<UserSession, Error>
}
