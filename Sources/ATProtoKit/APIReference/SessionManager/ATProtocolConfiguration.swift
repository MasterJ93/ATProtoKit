//
//  ATProtocolConfiguration.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation
import Logging

/// Manages authentication and session operations for the a user account in the ATProtocol.
public class ATProtocolConfiguration: SessionConfiguration {

    /// The user's handle identifier in their account.
    public var handle: String

    /// The password of the user's account.
    public var password: String

    /// The URL of the Personal Data Server (PDS).
    public var pdsURL: String

    /// An instance of `URLSessionConfiguration`.
    public let configuration: URLSessionConfiguration

    /// Specifies the logger that will be used for emitting log messages. Optional.
    private static let loggerManager = LogBootstrapConfiguration()

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

    /// The number of times a request can be attempted before it's considered a failure.
    ///
    /// By default, ATProtoKit will retry a request attempt for 1 second.
    public var maxRetryCount: Int?

    /// The length of time to wait before attempting to retry a request.
    ///
    /// By default, ATProtoKit will wait for 1 second before attempting to retry a request.
    /// ATProtoKit will change the number exponentally in order to help prevent overloading
    /// the server.
    public var retryTimeDelay: TimeInterval?

    /// The session attached to the configuration. Optional.
    public var session: UserSession?

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
//        userAgent: ATProtoTools.UserAgent = .default,
        logIdentifier: String? = nil,
        logCategory: String? = nil,
        logLevel: Logger.Level? = .info
    ) {
        self.handle = handle
        self.password = appPassword
        self.pdsURL = !pdsURL.isEmpty ? pdsURL : "https://bsky.social"
        self.configuration = configuration
//        self.userAgent = userAgent
        self.logIdentifier = logIdentifier ?? Bundle.main.bundleIdentifier ?? "com.cjrriley.ATProtoKit"
        self.logCategory = logCategory ?? "ATProtoKit"
        self.logLevel = logLevel

        Task { [configuration] in
            await ATProtocolConfiguration.loggerManager.setupLog(logCategory: logCategory, logLevel: logLevel, logIdentifier: logIdentifier)
            await APIClientService.shared.configure(with: configuration)
        }
    }

    /// Initializes a new instance of `ATProtocolConfiguration`, which assembles an a session
    /// specifically for a service.
    /// 
    /// This should only be used to create different instances of services where you don't need a
    /// handle or password.
    ///
    /// - Important: ``ATProtocolConfiguration/authenticate(authenticationFactorToken:)``,
    /// ``ATProtocolConfiguration/createAccount(email:handle:existingDID:inviteCode:verificationCode:verificationPhone:password:recoveryKey:plcOperation:)``,
    /// ``ATProtocolConfiguration/deleteSession()``,
    /// ``ATProtocolConfiguration/getSession(by:)``, and
    /// ``ATProtocolConfiguration/deleteSession()`` will not work when initializing
    /// ATProtocolConfiguration with this initializer.
    ///
    /// - Parameters:
    ///   - service: The web address of the service.
    ///   - configuration: An instance of `URLSessionConfiguration`. Optional.
    ///   - logIdentifier: Specifies the identifier for managing log outputs. Optional. Defaults
    ///   to the project's `CFBundleIdentifier`.
    ///   - logCategory: Specifies the category name the logs in the logger within ATProtoKit will
    ///   be in. Optional. Defaults to `ATProtoKit`.
    ///   - logLevel: Specifies the highest level of logs that will be outputted. Optional.
    ///   Defaults to `.info`.
    public init(
        service: String,
        configuration: URLSessionConfiguration = .default,
//        userAgent: ATProtoTools.UserAgent = .default,
        logIdentifier: String? = nil,
        logCategory: String? = nil,
        logLevel: Logger.Level? = .info
    ) {
        self.handle = ""
        self.password = ""
        self.pdsURL = service
        self.configuration = configuration
//        self.userAgent = userAgent
        self.logIdentifier = logIdentifier ?? Bundle.main.bundleIdentifier ?? "com.cjrriley.ATProtoKit"
        self.logCategory = logCategory ?? "ATProtoKit"
        self.logLevel = logLevel
    }

    /// Retrieves the current logger for usage.
    public static func getLogger() async -> Logger {
        return await loggerManager.getLogger()
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
    ///   - plcOperation: A signed DID PLC operation to be submitted as part of importing an
    ///   existing account to this instance. Optional.
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
        plcOperation: UnknownType? = nil
    ) async throws -> UserSession {
        do {
            let response = try await ATProtoKit().createAccount(
                email: email,
                handle: handle,
                existingDID: existingDID,
                inviteCode: inviteCode,
                verificationCode: verificationCode,
                verificationPhone: verificationPhone,
                password: password,
                recoveryKey: recoveryKey,
                plcOperation: plcOperation,
                pdsURL: self.pdsURL
            )

            // Convert `response.didDocument` to `UserSession.didDocument`.
            var decodedDidDocument: DIDDocument? = nil

            if let didDocument = response.didDocument,
               let jsonData = try didDocument.toJSON() {
                do {
                    let decoder = JSONDecoder()
                    decodedDidDocument = try decoder.decode(DIDDocument.self, from: jsonData)
                } catch {
                    throw error
                }
            }

            let userSession = UserSession(
                handle: response.handle,
                sessionDID: response.did,
                email: email,
                isEmailConfirmed: nil,
                isEmailAuthenticationFactorEnabled: nil,
                accessToken: response.accessToken,
                refreshToken: response.refreshToken,
                didDocument: decodedDidDocument,
                isActive: nil,
                status: nil,
                pdsURL: self.pdsURL,
                logger: await ATProtocolConfiguration.getLogger(),
                maxRetryCount: self.maxRetryCount,
                retryTimeDelay: self.retryTimeDelay
            )

            return userSession
        } catch {
            throw error
        }
    }

    /// Attempts to authenticate the user into the server.
    ///
    /// If the user has Two-Factor Authentication enabled, then `authenticationFactorToken`
    /// is required to be used. If the user is inputting their App Password, then the parameter
    /// shouldn't be used.
    ///
    /// When the method completes, ``ATProtocolConfiguration/session`` will be updated with an
    /// instance of an authenticated user session within the AT Protocol. It may also have logging
    /// information, as well as the URL of the Personal Data Server (PDS).
    ///
    /// - Parameter authenticationFactorToken: A token used for
    /// Two-Factor Authentication. Optional.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func authenticate(authenticationFactorToken: String? = nil) async throws {
        do {
            let response = try await ATProtoKit().createSession(
                with: self.handle,
                and: self.password,
                authenticationFactorToken: authenticationFactorToken,
                pdsURL: self.pdsURL
            )

            // Convert `response.didDocument` to `UserSession.didDocument`.
            var decodedDidDocument: DIDDocument? = nil

            if let didDocument = response.didDocument,
               let jsonData = try didDocument.toJSON() {
                do {
                    let decoder = JSONDecoder()
                    decodedDidDocument = try decoder.decode(DIDDocument.self, from: jsonData)
                } catch {
                    throw error
                }
            }

            var status: UserAccountStatus? = nil

            switch response.status {
                case .suspended:
                    status = .suspended
                case .takedown:
                    status = .takedown
                case .deactivated:
                    status = .deactivated
                default:
                    status = nil
            }

            let userSession = UserSession(
                handle: response.handle,
                sessionDID: response.did,
                email: response.email,
                isEmailConfirmed: response.isEmailConfirmed,
                isEmailAuthenticationFactorEnabled: response.isEmailAuthenticatedFactor,
                accessToken: response.accessToken,
                refreshToken: response.refreshToken,
                didDocument: decodedDidDocument,
                isActive: response.isActive,
                status: status,
                pdsURL: self.pdsURL,
                logger: await ATProtocolConfiguration.getLogger(),
                maxRetryCount: self.maxRetryCount,
                retryTimeDelay: self.retryTimeDelay
            )

            self.session = userSession
        } catch {
            throw error
        }
    }

    /// Fetches an existing session using an access token.
    ///
    /// If the access token is invalud, then a new one will be created, either by refeshing a
    /// session, or by re-authenticating.
    ///
    /// When the method completes, ``ATProtocolConfiguration/session`` will be updated with an
    /// instance of an authenticated user session within the AT Protocol. It may also have logging
    /// information, as well as the URL of the Personal Data Server (PDS).
    ///
    /// - Parameter accessToken: The access token used for the session. Optional.
    /// Defaults to `nil`.
    ///
    /// - Returns: Information of the user account's current session straight from the service.
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSession(by accessToken: String? = nil) async throws -> ComAtprotoLexicon.Server.GetSessionOutput? {
        do {
            // Check if accessToken has anything inserted. If not, use the accessToken from the UserSession object.
            guard let sessionToken = accessToken ?? self.session?.accessToken else { return nil }
            guard sessionToken == sessionToken else { return nil }

            let response = try await ATProtoKit().getSession(
                by: sessionToken,
                pdsURL: self.pdsURL
            )

            return response
        } catch {
            throw error
        }
    }

    /// Refreshes the user's session using a refresh token.
    ///
    /// If the refresh token is invalid, the method will re-authenticate and try again.
    ///
    /// - Note: If the method throws an error saying that an authentication token is required,
    /// re-trying the method with the `authenticationFactorToken` argument filled should
    /// solve the issue.
    ///
    /// When the method completes, ``ATProtocolConfiguration/session`` will be updated with a
    /// new instance of an authenticated user session within the AT Protocol. It may also have
    /// logging information, as well as the URL of the Personal Data Server (PDS).
    ///
    /// - Parameters:
    ///   - refreshToken: The refresh token used for the session. Optional.
    ///   Defaults to `nil`.
    ///   - authenticationFactorToken: A token used for Two-Factor Authentication. Optional.
    ///   Defaults to `nil`.
    ///
    /// - Returns: Information of the user account's new session.
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func refreshSession(
        by refreshToken: String? = nil,
        authenticationFactorToken: String? = nil
    ) async throws -> ComAtprotoLexicon.Server.RefreshSessionOutput {
        var sessionToken: String = ""

        if let token = refreshToken {
            sessionToken = token
        } else if let token = self.session?.refreshToken {
            sessionToken = token
        } else {
            do {
                try await self.authenticate(authenticationFactorToken: authenticationFactorToken)
            } catch {
                throw error
            }
        }

        do {
            let response = try await ATProtoKit().refreshSession(
                refreshToken: sessionToken,
                pdsURL: self.pdsURL
            )

            return response
        } catch let apiError as ATAPIError {
            // If the token expires, re-authenticate and try refreshing the token again.
            switch apiError {
                case .badRequest(let error):
                    // If the token expires, re-authenticate.
                    if error.error == "ExpiredToken" {
                        // If the token expires, re-authenticate.
                        do {
                            try await self.authenticate(authenticationFactorToken: authenticationFactorToken)

                            // Then, try refreshing the token again.
                            let response = try await ATProtoKit().refreshSession(
                                refreshToken: sessionToken,
                                pdsURL: self.pdsURL
                            )

                            return response
                        } catch {
                            throw error
                        }
                    }
                    throw apiError
                default:
                    throw apiError
            }
        }
    }

    /// Deletes the user session.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func deleteSession() async throws {
        do {
            guard let refreshToken = self.session?.refreshToken else { return }

            _ = try await ATProtoKit().deleteSession(
                refreshToken: refreshToken,
                pdsURL: self.pdsURL
            )

            self.session = nil
        } catch {
            throw error
        }
    }
}
