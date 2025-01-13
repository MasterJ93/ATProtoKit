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
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
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

    /// Initializes a new instance of `ATProtocolConfiguration`, which assembles a session based
    /// off of a ``UserSession`` instance.
    /// 
    /// - Parameters:
    ///   - userSession: An instance of ``UserSession``.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    ///   - configuration: An instance of `URLSessionConfiguration`. Optional.
    ///   - logIdentifier: Specifies the identifier for managing log outputs. Optional. Defaults
    ///   to the project's `CFBundleIdentifier`.
    ///   - logCategory: Specifies the category name the logs in the logger within ATProtoKit will
    ///   be in. Optional. Defaults to `ATProtoKit`.
    ///   - logLevel: Specifies the highest level of logs that will be outputted. Optional.
    ///   Defaults to `.info`.
    public init(
        userSession: UserSession,
        pdsURL: String = "https://bsky.social",
        configuration: URLSessionConfiguration = .default,
        logIdentifier: String? = nil,
        logCategory: String? = nil,
        logLevel: Logger.Level? = .info
    ) {
        self.handle = userSession.handle
        self.password = ""
        self.pdsURL = userSession.pdsURL ?? pdsURL
        self.configuration = configuration
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
    /// ``ATProtocolConfiguration/getSession(by:authenticationFactorToken:)``,
    /// ``ATProtocolConfiguration/refreshSession(by:authenticationFactorToken:)``and
    /// ``ATProtocolConfiguration/deleteSession(with:)`` will not work when initializing
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
            let response = try await ATProtoKit(canUseBlueskyRecords: false).createAccount(
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
            let response = try await ATProtoKit(canUseBlueskyRecords: false).createSession(
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
    /// If the access token is invalid, then a new one will be created, either by refeshing a
    /// session, or by re-authenticating.
    ///
    /// - Parameters:
    ///   - accessToken: The access token used for the session. Optional.
    ///   Defaults to `nil`.
    ///   - authenticationFactorToken: A token used for Two-Factor Authentication. Optional.
    /// - Returns: Information of the user account's current session straight from the service.
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSession(
        by accessToken: String? = nil,
        authenticationFactorToken: String? = nil
    ) async throws -> ComAtprotoLexicon.Server.GetSessionOutput {
        let sessionToken = try getValidAccessToken(from: accessToken)

        do {
            let response = try await ATProtoKit(canUseBlueskyRecords: false).getSession(
                by: sessionToken,
                pdsURL: self.pdsURL
            )

            return response
        } catch let apiError as ATAPIError {
            guard case .badRequest(let errorDetails) = apiError,
                  errorDetails.error == "ExpiredToken" else {
                throw apiError
            }

            return try await handleExpiredTokenFromGetSession(authenticationFactorToken: authenticationFactorToken)
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
    /// - Note: If you rely on ``ATProtocolConfiguration/session`` for managing the session,
    /// there's no need to use the `refreshToken` argument.
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
            let response = try await ATProtoKit(canUseBlueskyRecords: false).refreshSession(
                refreshToken: sessionToken,
                pdsURL: self.pdsURL
            )

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
                email: session?.email ?? nil,
                isEmailConfirmed: session?.isEmailConfirmed ?? nil,
                isEmailAuthenticationFactorEnabled: session?.isEmailAuthenticationFactorEnabled ?? nil,
                accessToken: response.accessToken,
                refreshToken: response.refreshToken,
                didDocument: decodedDidDocument,
                isActive: response.isActive,
                status: status,
                pdsURL: session?.pdsURL ?? nil,
                logger: await ATProtocolConfiguration.getLogger(),
                maxRetryCount: self.maxRetryCount,
                retryTimeDelay: self.retryTimeDelay
            )

            self.session = userSession
            return response
        } catch let apiError as ATAPIError {
            // If the token expires, re-authenticate and try refreshing the token again.
            guard case .badRequest(let errorDetails) = apiError,
                  errorDetails.error == "ExpiredToken" else {
                throw apiError
            }

            return try await handleExpiredTokenFromRefreshSession(authenticationFactorToken: authenticationFactorToken)
        }
    }

    /// Deletes the user session.
    ///
    /// - Note: If you rely on ``ATProtocolConfiguration/session`` for managing the session,
    /// there's no need to use the `refreshToken` argument.
    /// 
    /// - Parameter refreshToken: The refresh token used for the session. Optional.
    /// Defaults to `nil`.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func deleteSession(with refreshToken: String? = nil) async throws {
        do {
            var token: String

            if let refreshToken = refreshToken {
                token = refreshToken
            } else if let sessionToken = self.session?.refreshToken {
                token = sessionToken
            } else {
                return
            }

            _ = try await ATProtoKit(canUseBlueskyRecords: false).deleteSession(
                refreshToken: token,
                pdsURL: self.pdsURL
            )

            self.session = nil
        } catch {
            throw error
        }
    }

    /// Resumes a session.
    ///  
    /// This is useful for cases where a user is opening the app and they've already logged in.
    /// 
    /// While inserting the access token is optional, the refresh token is not, as it lasts much
    /// longer than the refresh token.
    ///
    /// - Warning: This is an experimental method. This may be removed at a later date if
    /// it doesn't prove to be helpful.
    ///
    /// If the refresh token fails for whatever reason, it's recommended to call
    /// ``ATProtocolConfiguration/authenticate(authenticationFactorToken:)``
    /// in the `catch` block.
    ///
    /// - Parameters:
    ///   - accessToken: The access token of the session. Optional.
    ///   - refreshToken: The refresh token of the session.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func resumeSession(
        accessToken: String? = nil,
        refreshToken: String,
        pdsURL: String = "https://bsky.social"
    ) async throws {
        if let sessionToken = accessToken ?? self.session?.accessToken {
            let expiryDate = try SessionToken(sessionToken: sessionToken).payload.expiresAt
            let currentDate = Date()

            if currentDate > expiryDate {
                do {
                    try await self.checkRefreshToken(refreshToken: refreshToken, pdsURL: pdsURL)
                } catch {
                    throw error
                }
            }

            _ = try await self.getSession(by: accessToken)
        } else {
            do {
                try await self.checkRefreshToken(refreshToken: refreshToken)
            } catch {
                throw error
            }
        }
    }

// MARK: - Common Helpers
    /// Converts the DID document from an ``UnknownType`` object to a ``DIDDocument`` object.
    ///
    /// - Parameter didDocument: The DID document as an ``UnknownType`` object. Optional.
    /// Defaults to `nil`.
    /// - Returns: A ``DIDDocument`` object (if there's a value) or `nil` (if not).
    private func convertDIDDocument(_ didDocument: UnknownType? = nil) -> DIDDocument? {
        var decodedDidDocument: DIDDocument? = nil

        do {
            if let didDocument = didDocument,
               let jsonData = try didDocument.toJSON() {
                let decoder = JSONDecoder()
                decodedDidDocument = try decoder.decode(DIDDocument.self, from: jsonData)
            }
        } catch {
            return nil
        }

        return decodedDidDocument
    }

    /// Checks the refresh token and refreshes the session.
    ///
    /// - Parameter refreshToken: The refresh token of the session.
    ///
    /// - Throws: ``ATProtocolConfigurationError`` if the current date is past the token's
    /// expiry date.
    private func checkRefreshToken(refreshToken: String, pdsURL: String = "https://bsky.social") async throws {
        let expiryDate = try SessionToken(sessionToken: refreshToken).payload.expiresAt
        let currentDate = Date()

        if currentDate > expiryDate {
            throw ATProtocolConfigurationError.tokensExpired(message: "The access and refresh tokens have expired.")
        }

        do {
            _ = try await self.refreshSession(by: refreshToken)
        } catch {
            throw error
        }
    }

// MARK: - getSession Helpers
    /// Validates and retrieves a valid access token from the provided argument or the session object.
    ///
    /// - Parameter accessToken: An optional access token to validate.
    /// - Returns: A valid access token.
    ///
    /// - Throws: An `ATProtoError` if no access token is available.
    private func getValidAccessToken(from accessToken: String?) throws -> String {
        if let token = accessToken {
            return token
        }

        if let token = self.session?.accessToken {
            return token
        }

        throw ATProtocolConfigurationError.noSessionToken(message: "No session token available.")
    }

    /// Handles re-authentication and session refresh when the token is expired.
    ///
    /// - Parameter authenticationFactorToken: A token used for Two-Factor Authentication.
    /// Optional. Defaults to `nil`.
    /// - Returns: A refreshed session object.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError``, ``ATRequestPrepareError``, and
    /// ``ATProtocolConfigurationError`` for more details.
    private func handleExpiredTokenFromGetSession(
        authenticationFactorToken: String? = nil
    ) async throws -> ComAtprotoLexicon.Server.GetSessionOutput {
        do {
            _ = try await self.refreshSession(authenticationFactorToken: authenticationFactorToken)

            guard let session = self.session else {
                throw ATProtocolConfigurationError.noSessionToken(message: "No session token found after re-authentication attempt.")
            }

            var refreshedSessionStatus: ComAtprotoLexicon.Server.GetSession.UserAccountStatus? = nil

            // UserAccountStatus conversion.
            let sessionStatus = session.status
            switch sessionStatus {
                case .suspended:
                    refreshedSessionStatus = .suspended
                case .takedown:
                    refreshedSessionStatus = .takedown
                case .deactivated:
                    refreshedSessionStatus = .deactivated
                default:
                    refreshedSessionStatus = nil
            }

            // DIDDocument conversion.
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted

            let jsonData = try encoder.encode(session.didDocument)

            guard let rawDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(codingPath: [], debugDescription: "Failed to serialize DIDDocument into [String: Any].")
                )
            }

            var codableDictionary = [String: CodableValue]()
            for (key, value) in rawDictionary {
                codableDictionary[key] = try CodableValue.fromAny(value)
            }

            let didDocument = UnknownType.unknown(codableDictionary)

            return ComAtprotoLexicon.Server
                .GetSessionOutput(
                    handle: session.handle,
                    did: session.sessionDID,
                    email: session.email,
                    isEmailConfirmed: session.isEmailConfirmed,
                    isEmailAuthenticationFactor: session.isEmailAuthenticationFactorEnabled,
                    didDocument: didDocument,
                    isActive: session.isActive,
                    status: refreshedSessionStatus
                )
        } catch {
            throw error
        }
    }

// MARK: - refreshSession Helpers
    /// Validates and retrieves a valid access token from the provided argument or the session object.
    ///
    /// - Parameter accessToken: An optional access token to validate.
    /// - Returns: A valid access token.
    ///
    /// - Throws: An `ATProtoError` if no access token is available.
    private func getValidRefreshToken(from refreshToken: String?) throws -> String {
        if let token = refreshToken {
            return token
        }

        if let token = self.session?.refreshToken {
            return token
        }

        throw ATProtocolConfigurationError.noSessionToken(message: "No session token available.")
    }

    /// Handles re-authentication and session refresh when the token is expired.
    ///
    /// - Parameter authenticationFactorToken: A token used for Two-Factor Authentication.
    /// Optional. Defaults to `nil`.
    /// - Returns: A refreshed session object.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError``, ``ATRequestPrepareError``, and
    /// ``ATProtocolConfigurationError`` for more details.
    private func handleExpiredTokenFromRefreshSession(
        authenticationFactorToken: String? = nil
    ) async throws -> ComAtprotoLexicon.Server.RefreshSessionOutput {
        do {
            try await self.authenticate(authenticationFactorToken: authenticationFactorToken)

            guard let session = self.session else {
                throw ATProtocolConfigurationError.noSessionToken(message: "No session token found after re-authentication attempt.")
            }

            var refreshedSessionStatus: ComAtprotoLexicon.Server.RefreshSession.UserAccountStatus? = nil

            // UserAccountStatus conversion.
            let sessionStatus = session.status
            switch sessionStatus {
                case .suspended:
                    refreshedSessionStatus = .suspended
                case .takedown:
                    refreshedSessionStatus = .takedown
                case .deactivated:
                    refreshedSessionStatus = .deactivated
                default:
                    refreshedSessionStatus = nil
            }

            // DIDDocument conversion.
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted

            let jsonData = try encoder.encode(session.didDocument)

            guard let rawDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(codingPath: [], debugDescription: "Failed to serialize DIDDocument into [String: Any].")
                )
            }

            var codableDictionary = [String: CodableValue]()
            for (key, value) in rawDictionary {
                codableDictionary[key] = try CodableValue.fromAny(value)
            }

            let didDocument = UnknownType.unknown(codableDictionary)

            return ComAtprotoLexicon.Server.RefreshSessionOutput(
                accessToken: session.accessToken,
                refreshToken: session.refreshToken,
                handle: session.handle,
                did: session.sessionDID,
                didDocument: didDocument,
                isActive: session.isActive,
                status: refreshedSessionStatus
            )
        } catch {
            throw error
        }
    }
}
