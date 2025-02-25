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
    var handle: String { get set }

    /// The password associated with the user's account, used for authentication.
    var password: String { get set }

    /// The decentralized identifier (DID), serving as a persistent and long-term account
    /// identifier according to the W3C standard.
    var sessionDID: String { get set }

    /// The user's email address. Optional.
    var email: String? { get set }

    /// Indicates whether the user's email address has been confirmed. Optional.
    var isEmailConfirmed: Bool? { get set }

    /// Indicates whether Two-Factor Authentication (via email) is enabled. Optional.
    var isEmailAuthenticationFactorEnabled: Bool? { get set }

    /// The access token used for API requests that requests authentication.
    var accessToken: String? { get set }

    /// The refresh token used to generate a new access token.
    var refreshToken: String? { get set }

    /// The DID document associated with the user, which contains AT Protocol-specific
    /// information. Optional.
    var didDocument: DIDDocument? { get set }

    /// Indicates whether the user account is active. Optional.
    var isActive: Bool? { get set }

    /// Indicates the possible reason for why the user account is inactive. Optional.
    var status: UserAccountStatus? { get set }

    /// The user account's endpoint used for sending authentication requests.
    var serviceEndpoint: URL { get set }

    /// The base URL of the Personal Data Server (PDS) with which the AT Protocol interacts.
    ///
    /// This URL is used to make network requests to the PDS for various operations, such as
    /// session creation, refresh, and deletion.
    var pdsURL: String { get set }

    /// Specifies the logger that will be used for emitting log messages. Optional.
    ///
    /// - Note: This is not included when initalizing `UserSession`. Instead, it's added
    /// after the successful initalizing.
    var logger: Logger? { get set }

    /// The number of times a request can be attempted before it's considered a failure.
    ///
    /// By default, ATProtoKit will retry a request attempt for 1 second.
    ///
    /// - Note: This is not included when initalizing `UserSession`. Instead, it's added
    /// after the successful initalizing.
    var maxRetryCount: Int? { get set }

    /// The length of time to wait before attempting to retry a request.
    ///
    /// By default, ATProtoKit will wait for 1 second before attempting to retry a request.
    /// ATProtoKit will change the number exponentally in order to help prevent overloading
    /// the server.
    ///
    /// - Note: This is not included when initalizing `UserSession`. Instead, it's added
    /// after the successful initalizing.
    var retryTimeDelay: TimeInterval? { get set }


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
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    func createAccount(
        email: String?,
        handle: String,
        existingDID: String?,
        inviteCode: String?,
        verificationCode: String?,
        verificationPhone: String?,
        password: String?,
        recoveryKey: String?,
        plcOperation: UnknownType?
    ) async throws

    /// Fetches an existing session using an access token.
    ///
    /// If the access token is invalid, then a new one will be created, either by refeshing a
    /// session, or by re-authenticating.
    ///
    /// - Parameters:
    ///   - accessToken: The access token used for the session. Optional.
    ///   Defaults to `nil`.
    ///   - authenticationFactorToken: A token used for Two-Factor Authentication. Optional.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    func getSession(by accessToken: String?, authenticationFactorToken: String?) async throws

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
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    func refreshSession(by refreshToken: String?, authenticationFactorToken: String?) async throws

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
    func resumeSession(accessToken: String?, refreshToken: String) async throws

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
    func deleteSession(with refreshToken: String?) async throws
}

extension SessionConfiguration {

    public mutating func authenticate(authenticationFactorToken: String? = nil) async throws {
        let sessionConfiguration = SessionConfigurationTools(sessionConfiguration: self)

        do {
            let response = try await ATProtoKit(pdsURL: self.pdsURL, canUseBlueskyRecords: false).createSession(
                with: self.handle,
                and: self.password,
                authenticationFactorToken: authenticationFactorToken
            )

            guard let didDocument = sessionConfiguration.convertDIDDocument(response.didDocument) else {
                throw DIDDocument.DIDDocumentError.emptyArray
            }

            let atService = try didDocument.checkServiceForATProto()
            let serviceEndpoint = atService.serviceEndpoint

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

            self.handle = response.handle
            self.sessionDID = response.did
            self.email = response.email
            self.isEmailConfirmed = response.isEmailConfirmed
            self.isEmailAuthenticationFactorEnabled = response.isEmailAuthenticatedFactor
            self.accessToken = response.accessToken
            self.refreshToken = response.refreshToken
            self.didDocument = didDocument
            self.isActive = response.isActive
            self.status = status
            self.serviceEndpoint = serviceEndpoint
            self.logger = await ATProtocolConfiguration.getLogger()
        } catch {
            throw error
        }
    }

    public mutating func createAccount(
        email: String?,
        handle: String,
        existingDID: String?,
        inviteCode: String?,
        verificationCode: String?,
        verificationPhone: String?,
        password: String?,
        recoveryKey: String?,
        plcOperation: UnknownType?
    ) async throws {
        let sessionConfiguration = SessionConfigurationTools(sessionConfiguration: self)

        let response = try await ATProtoKit(pdsURL: self.pdsURL, canUseBlueskyRecords: false).createAccount(
            email: email,
            handle: handle,
            existingDID: existingDID,
            inviteCode: inviteCode,
            verificationCode: verificationCode,
            verificationPhone: verificationPhone,
            password: password,
            recoveryKey: recoveryKey,
            plcOperation: plcOperation
        )

        guard let didDocument = sessionConfiguration.convertDIDDocument(response.didDocument) else {
            throw DIDDocument.DIDDocumentError.emptyArray
        }

        let atService = try didDocument.checkServiceForATProto()
        let serviceEndpoint = atService.serviceEndpoint

        self.handle = response.handle
        self.sessionDID = response.did
        self.email = email
        self.accessToken = response.accessToken
        self.refreshToken = response.refreshToken
        self.didDocument = didDocument
        self.serviceEndpoint = serviceEndpoint
        self.logger = await ATProtocolConfiguration.getLogger()
    }

    public mutating func getSession(by accessToken: String? = nil, authenticationFactorToken: String? = nil) async throws {
        let sessionConfiguration = SessionConfigurationTools(sessionConfiguration: self)

        var sessionToken: String = ""
        do {
            sessionToken = try sessionConfiguration.getValidAccessToken(from: accessToken)
        } catch {
            throw error
        }

        do {
            let response = try await ATProtoKit(pdsURL: self.pdsURL, canUseBlueskyRecords: false).getSession(
                by: sessionToken
            )

            guard let didDocument = sessionConfiguration.convertDIDDocument(response.didDocument) else {
                throw DIDDocument.DIDDocumentError.emptyArray
            }

            let atService = try didDocument.checkServiceForATProto()
            let serviceEndpoint = atService.serviceEndpoint

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

            self.handle = response.handle
            self.sessionDID = response.did
            self.email = response.email
            self.isEmailConfirmed = response.isEmailConfirmed
            self.isEmailAuthenticationFactorEnabled = response.isEmailAuthenticationFactor
            self.accessToken = sessionToken
            self.didDocument = didDocument
            self.isActive = response.isActive
            self.status = status
            self.serviceEndpoint = serviceEndpoint
            self.logger = await ATProtocolConfiguration.getLogger()
        } catch let apiError as ATAPIError {
            guard case .badRequest(let errorDetails) = apiError,
                  errorDetails.error == "ExpiredToken" else {
                throw apiError
            }

            _ = try await sessionConfiguration.handleExpiredTokenFromGetSession(authenticationFactorToken: authenticationFactorToken)
        }
    }

    public mutating func refreshSession(
        by refreshToken: String? = nil,
        authenticationFactorToken: String? = nil
    ) async throws {
        let sessionConfiguration = SessionConfigurationTools(sessionConfiguration: self)
        var sessionToken: String = ""

        let token = sessionConfiguration.getValidRefreshToken(from: self.refreshToken)

        if let token = sessionConfiguration.getValidRefreshToken(from: self.refreshToken) {
            sessionToken = token
        } else {
            do {
                try await self.authenticate(authenticationFactorToken: authenticationFactorToken)
            } catch {
                throw error
            }
        }

        do {
            let response = try await ATProtoKit(pdsURL: self.pdsURL, canUseBlueskyRecords: false).refreshSession(
                refreshToken: sessionToken
            )

            guard let didDocument = sessionConfiguration.convertDIDDocument(response.didDocument) else {
                throw DIDDocument.DIDDocumentError.emptyArray
            }

            let atService = try didDocument.checkServiceForATProto()
            let serviceEndpoint = atService.serviceEndpoint

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

            self.handle = response.handle
            self.sessionDID = response.did
            self.accessToken = response.accessToken
            self.refreshToken = response.refreshToken
            self.didDocument = didDocument
            self.isActive = response.isActive
            self.status = status
            self.serviceEndpoint = serviceEndpoint
            self.logger = await ATProtocolConfiguration.getLogger()
        } catch let apiError as ATAPIError {
            // If the token expires, re-authenticate and try refreshing the token again.
            guard case .badRequest(let errorDetails) = apiError,
                  errorDetails.error == "ExpiredToken" else {
                throw apiError
            }

            _ = try await sessionConfiguration.handleExpiredTokenFromRefreshSession(authenticationFactorToken: authenticationFactorToken)
        }
    }

    public mutating func resumeSession(
        accessToken: String? = nil,
        refreshToken: String,
        pdsURL: String = "https://bsky.social"
    ) async throws {
        let sessionConfiguration = SessionConfigurationTools(sessionConfiguration: self)

        if let sessionToken = accessToken ?? self.accessToken {
            let expiryDate = try SessionToken(sessionToken: sessionToken).payload.expiresAt
            let currentDate = Date()

            if currentDate > expiryDate {
                do {
                    try await sessionConfiguration.checkRefreshToken(refreshToken: refreshToken, pdsURL: pdsURL)
                } catch {
                    throw error
                }
            }

            _ = try await self.getSession(by: accessToken)
        } else {
            do {
                try await sessionConfiguration.checkRefreshToken(refreshToken: refreshToken)
            } catch {
                throw error
            }
        }
    }

    public mutating func deleteSession(with refreshToken: String? = nil) async throws {
        do {
            var token: String

            if let refreshToken = refreshToken {
                token = refreshToken
            } else if let sessionToken = self.refreshToken {
                token = sessionToken
            } else {
                return
            }

            _ = try await ATProtoKit(pdsURL: self.pdsURL, canUseBlueskyRecords: false).deleteSession(
                refreshToken: token
            )
        } catch {
            throw error
        }
    }
}
