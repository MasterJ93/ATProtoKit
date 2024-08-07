//
//  ATProtocolConfiguration.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation
import Logging

/// Manages authentication and session operations for the a user account in the ATProtocol.
public class ATProtocolConfiguration: ProtocolConfiguration {

    /// The user's handle identifier in their account.
    public var handle: String

    /// The app password of the user's account.
    public var appPassword: String

    /// The URL of the Personal Data Server (PDS).
    public var pdsURL: String

    /// An instance of `URLSessionConfiguration`.
    public let configuration: URLSessionConfiguration

    /// Specifies the logger that will be used for emitting log messages.
    public private(set) var logger: Logger?

    /// Specifies the identifier for managing log outputs. Optional. Defaults to the
    /// project's `CFBundleIdentifier`.
    public let logIdentifier: String?

    /// Specifies the category name the logs in the logger within ATProtoKit will be in. Optional.
    /// Defaults to `ATProtoKit`.
    ///
    /// - Note: This property is ignored if you're using `StreamLogHandler`.
    public let logCategory: String?

    /// Specifies the highest level of logs that will be outputted. Optional. Defaults to `.info`.
    public let logLevel: Logger.Level?

    /// Specifies the logger that will be used for emitting log messages.
    private static var sharedLogger: Logger?

    /// Initializes a new instance of `ATProtocolConfiguration`, which assembles a new session
    /// for the user account.
    ///
    /// - Parameters:
    ///   - handle: The user's handle identifier in their account.
    ///   - appPassword: The app password of the user's account.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    ///   - configuration: An instance of `URLSessionConfiguration`. Optional.
    ///   - logIdentifier: Specifies the identifier for managing log outputs. Optional. Defaults
    ///   to the project's `CFBundleIdentifier`.
    ///   - logCategory: Specifies the category name the logs in the logger within ATProtoKit will
    ///   be in. Optional. Defaults to `ATProtoKit`.
    ///   - logLevel: Specifies the highest level of logs that will be outputted. Optional.
    ///   Defaults to `.info`.
    public init(
        handle: String,
        appPassword: String,
        pdsURL: String = "https://bsky.social",
        configuration: URLSessionConfiguration = .default,
        logIdentifier: String? = nil,
        logCategory: String? = nil,
        logLevel: Logger.Level? = .info) {
            self.handle = handle
            self.appPassword = appPassword
            self.pdsURL = !pdsURL.isEmpty ? pdsURL : "https://bsky.social"
            self.configuration = configuration
            self.logIdentifier = logIdentifier ?? Bundle.main.bundleIdentifier ?? "com.cjrriley.ATProtoKit"
            self.logCategory = logCategory ?? "ATProtoKit"
            self.logLevel = logLevel


            if ATProtocolConfiguration.sharedLogger == nil {
                #if canImport(os)
                LoggingSystem.bootstrap { label in
                    ATLogHandler(subsystem: label, category: logCategory ?? "ATProtoKit")
                }
                #else
                LoggingSystem.bootstrap(StreamLogHandler.standardOutput)
                #endif

                ATProtocolConfiguration.sharedLogger = Logger(label: self.logIdentifier ?? "com.cjrriley.ATProtoKit")
                ATProtocolConfiguration.sharedLogger?.logLevel = logLevel ?? .info
            }

            self.logger = ATProtocolConfiguration.sharedLogger

            APIClientService.configure(with: self.configuration)


    }
    
    /// Attempts to authenticate the user into the server.
    ///
    /// If the user has Two-Factor Authentication enabled, then `authenticationFactorToken`
    /// is required to be used. If the user is inputting their App Password, then the parameter
    /// shouldn't be used.
    ///
    /// - Note: According to the AT Protocol specifications: "Handle or other identifier supported
    /// by the server for the authenticating user."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createSession.json
    ///
    /// - Parameter authenticationFactorToken: A token used for
    /// Two-Factor Authentication. Optional.
    /// - Returns: An instance of an authenticated user session within the AT Protocol. It may also
    /// have logging information, as well as the URL of the Personal Data Server (PDS).
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func authenticate(authenticationFactorToken: String? = nil) async throws -> UserSession {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.server.createSession") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let credentials = ComAtprotoLexicon.Server.CreateSessionRequestBody(
            identifier: handle,
            password: appPassword,
            authenticationFactorToken: authenticationFactorToken
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post
            )
            var response = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: credentials,
                decodeTo: UserSession.self
            )
            response.pdsURL = self.pdsURL

            if self.logger != nil {
                response.logger = self.logger
            }

            return response
        } catch {
            throw error
        }
    }
    
    /// Creates an a new account for the user.
    ///
    /// - Note: `plcOp` may be updated when full account migration is implemented.
    ///
    /// - Bug: `plcOp` is currently broken: there's nothing that can be used for this at the
    /// moment while Bluesky continues to work on account migration. Until everything settles
    /// and they have a concrete example of what to do, don't use it. In the meantime, leave it
    /// at `nil`.
    ///
    /// - Note: According to the AT Protocol specifications: "Create an account. Implemented
    /// by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createAccount`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createAccount.json
    ///
    /// - Parameters:
    ///   - email: The email of the user. Optional
    ///   - handle: The handle the user wishes to use.
    ///   - existingDID: A decentralized identifier (DID) that has existed before and will be
    ///   used to be imported to the new account. Optional.
    ///   - inviteCode: The invite code for the user. Optional.
    ///   - verificationCode: A verification code.
    ///   - verificationPhone: A code that has come from a text message in the user's
    ///   phone. Optional.
    ///   - password: The password the user will use for the account. Optional.
    ///   - recoveryKey: DID PLC rotation key (aka, recovery key) to be included in PLC
    ///   creation operation. Optional.
    ///   - plcOp: A signed DID PLC operation to be submitted as part of importing an existing
    ///   account to this instance. Optional.
    /// - Returns: An instance of an authenticated user session within the AT Protocol. It may also
    /// have logging information, as well as the URL of the Personal Data Server (PDS).
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func createAccount(
        email: String? = nil,
        handle: String,
        existingDID: String? = nil,
        inviteCode: String? = nil,
        verificationCode: String? = nil,
        verificationPhone: String? = nil,
        password: String? = nil,
        recoveryKey: String? = nil,
        plcOp: UnknownType? = nil
    ) async throws -> UserSession {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.server.createAccount") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Server.CreateAccountRequestBody(
            email: email,
            handle: handle,
            existingDID: existingDID,
            inviteCode: inviteCode,
            verificationCode: verificationCode,
            verificationPhone: verificationPhone,
            password: password,
            recoveryKey: recoveryKey,
            plcOp: plcOp
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: nil,
                contentTypeValue: nil,
                authorizationValue: nil
            )
            var response = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: UserSession.self
            )
            response.pdsURL = self.pdsURL

            if self.logger != nil {
                response.logger = self.logger
            }

            return response
        } catch {
            throw error
        }
    }

    /// Fetches an existing session using an access token.
    ///
    /// - Note: According to the AT Protocol specifications: "Get information about the current
    /// auth session. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.getSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/getSession.json
    ///
    /// - Parameters:
    ///   - accessToken: The access token for the session.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: An instance of the session-related information what contains a session response
    /// within the AT Protocol.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSession(
        by accessToken: String,
        pdsURL: String? = nil
    ) async throws -> SessionResponse {
        guard let sessionURL = pdsURL != nil ? pdsURL : self.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.getSession") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: SessionResponse.self
            )

            return response
        } catch {
            throw error
        }
    }

    /// Refreshes the user's session using a refresh token.
    /// 
    /// - Note: According to the AT Protocol specifications: "Refresh an authentication session.
    /// Requires auth using the 'refreshJwt' (not the 'accessJwt')."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.refreshSession`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/refreshSession.json
    /// 
    /// - Parameters:
    ///   - refreshToken: The refresh token for the session.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: An instance of an authenticated user session within the AT Protocol. It may also
    /// have logging information, as well as the URL of the Personal Data Server (PDS).
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func refreshSession(
        using refreshToken: String,
        pdsURL: String? = nil
    ) async throws -> UserSession {
        guard let sessionURL = pdsURL != nil ? pdsURL : self.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.refreshSession") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         authorizationValue: "Bearer \(refreshToken)")
            var response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: UserSession.self
            )
            response.pdsURL = self.pdsURL

            if self.logger != nil {
                response.logger = self.logger
            }

            return response
        } catch {
            throw error
        }
    }
    
    /// Refreshes the user's session using a refresh token.
    /// 
    /// - Note: According to the AT Protocol specifications: "Delete the current session.
    /// Requires auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.deleteSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/deleteSession.json
    ///
    /// - Parameters:
    ///   - accessToken: The access token for the session.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func deleteSession(
        using accessToken: String,
        pdsURL: String? = nil
    ) async throws {
        guard let sessionURL = pdsURL != nil ? pdsURL : self.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.deleteSession") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                authorizationValue: "Bearer \(accessToken)"
            )

            _ = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: nil
            )
        } catch {
            throw error
        }
    }
}
