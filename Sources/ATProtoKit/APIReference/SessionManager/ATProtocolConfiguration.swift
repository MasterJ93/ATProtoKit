//
//  ATProtocolConfiguration.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation

/// Manages authentication and session operations for the a user account in the ATProtocol.
final public class ATProtocolConfiguration: SessionConfiguration {

    public let instanceUUID: UUID

    public let pdsURL: String

    public let codeStream: AsyncStream<String>

    public let codeContinuation: AsyncStream<String>.Continuation

    public let keychainProtocol: SecureKeychainProtocol

    /// An instance of `URLSessionConfiguration`.
    public let configuration: URLSessionConfiguration

    /// Determines whether `ATProtocolConfiguration` will automatically resolve the handle.
    public let canResolve: Bool

    /// Initializes a new instance of `ATProtocolConfiguration`.
    ///
    /// - Parameters:
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    ///   - keychainProtocol: An instance of `SecureKeychainProtocol`. Optional. Defaults to `nil`.
    ///   - configuration: An instance of `URLSessionConfiguration`. Optional.
    ///   - canResolve: Indicates whether `ATProtocolConfiguration` will automatically resolve
    ///   the handle. Defaults to `true`.
    public init<Keychain: SecureKeychainProtocol>(
        pdsURL: String = "https://bsky.social",
        keychainProtocol: Keychain,
        configuration: URLSessionConfiguration = .default,
        canResolve: Bool = true
    ) {
        self.keychainProtocol = keychainProtocol
        self.instanceUUID = keychainProtocol.identifier
        self.pdsURL = pdsURL

        let (stream, continuation) = AsyncStream<String>.makeStream()
        self.codeStream = stream
        self.codeContinuation = continuation

        self.configuration = configuration
        self.canResolve = canResolve
    }

//    /// Resumes a session.
//    ///  
//    /// This is useful for cases where a user is opening the app and they've already logged in.
//    /// 
//    /// While inserting the access token is optional, the refresh token is not, as it lasts much
//    /// longer than the refresh token.
//    ///
//    /// - Warning: This is an experimental method. This may be removed at a later date if
//    /// it doesn't prove to be helpful.
//    ///
//    /// If the refresh token fails for whatever reason, it's recommended to call
//    /// ``ATProtocolConfiguration/authenticate(authenticationFactorToken:)``
//    /// in the `catch` block.
//    ///
//    /// - Parameters:
//    ///   - accessToken: The access token of the session. Optional.
//    ///   - refreshToken: The refresh token of the session.
//    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
//    ///
//    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
//    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
//    public func resumeSession(
//        accessToken: String? = nil,
//        refreshToken: String,
//        pdsURL: String = "https://bsky.social"
//    ) async throws {
//        if let sessionToken = accessToken ?? self.session?.accessToken {
//            let expiryDate = try SessionToken(sessionToken: sessionToken).payload.expiresAt
//            let currentDate = Date()
//
//            if currentDate > expiryDate {
//                do {
//                    try await self.checkRefreshToken(refreshToken: refreshToken, pdsURL: pdsURL)
//                } catch {
//                    throw error
//                }
//            }
//
//            _ = try await self.getSession(by: accessToken)
//        } else {
//            do {
//                try await self.checkRefreshToken(refreshToken: refreshToken)
//            } catch {
//                throw error
//            }
//        }
//    }
}
