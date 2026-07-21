//
//  SessionCapabilities.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2026-07-12.
//

import Foundation

/// Manages the relationship between a session configuration and ``UserSessionRegistry``.
public protocol UserSessionRegistryManaging: SessionConfiguration {

    /// Loads the current session and registers its public context.
    ///
    /// - Throws: An error if the session cannot be loaded or registered.
    func registerSession() async throws

    /// Removes the current session and its associated external resources.
    ///
    /// - Throws: An error if the session cannot be removed.
    func removeSession() async throws
}

/// Stores the credentials used by an App Password session.
public protocol AppPasswordCredentialStoring: SessionConfiguration {

    /// The secure store containing the App Password and legacy session tokens.
    var keychainProtocol: SecureKeychainProtocol { get }
}

/// Authenticates and maintains a legacy App Password session.
public protocol AppPasswordAuthenticating: AppPasswordCredentialStoring {

    /// The stream that receives user-provided authentication-factor codes.
    var codeStream: AsyncStream<String> { get }

    /// The continuation that supplies authentication-factor codes to ``codeStream``.
    var codeContinuation: AsyncStream<String>.Continuation { get }

    /// Authenticates an account with its handle and App Password.
    ///
    /// - Parameters:
    ///   - handle: The account handle.
    ///   - password: The account's App Password.
    ///
    /// - Throws: An error if authentication fails.
    func authenticate(with handle: String, password: String) async throws

    /// Refreshes the legacy access and refresh tokens.
    ///
    /// - Throws: An error if token refresh or reauthentication fails.
    func refreshSession() async throws

    /// Ensures the legacy access token remains valid.
    ///
    /// - Throws: An error if token inspection or refresh fails.
    func ensureValidToken() async throws

    /// Waits for the next user-provided authentication-factor code.
    ///
    /// - Returns: The next code, or an empty string when the stream ends.
    func waitForUserCode() async -> String

    /// Supplies an authentication-factor code to the active authentication attempt.
    ///
    /// - Parameter input: The authentication-factor code.
    func receiveCodeFromUser(_ input: String)
}

/// Creates AT Protocol accounts through a session configuration.
public protocol ATAccountCreating: SessionConfiguration {

    /// Creates an account on the configured Personal Data Server.
    ///
    /// - Parameters:
    ///   - email: The account email. Optional.
    ///   - handle: The requested account handle.
    ///   - existingDID: An existing decentralized identifier to import. Optional.
    ///   - inviteCode: The account invitation code. Optional.
    ///   - verificationCode: The email verification code. Optional.
    ///   - verificationPhone: The phone verification code. Optional.
    ///   - password: The account password. Optional.
    ///   - recoveryKey: The DID PLC recovery key. Optional.
    ///   - plcOperation: A signed DID PLC operation. Optional.
    ///
    /// - Throws: An error if account creation or session registration fails.
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
}

/// Combines the capabilities required by ATProtoKit's built-in App Password implementation.
public protocol AppPasswordSessionManaging: AppPasswordAuthenticating, ATAccountCreating, UserSessionRegistryManaging {}

/// Synchronizes session context owned by an external AT Protocol OAuth implementation.
public protocol OAuthSessionSynchronizing: UserSessionRegistryManaging {

    /// Reloads and registers the externally managed OAuth session context.
    ///
    /// - Throws: An error if the external context cannot be loaded or registered.
    func synchronizeSession() async throws
}

extension AppPasswordAuthenticating {

    /// Waits for the next authentication-factor code.
    ///
    /// - Returns: The next code, or an empty string when the stream ends.
    public func waitForUserCode() async -> String {
        var iterator = codeStream.makeAsyncIterator()
        return await iterator.next() ?? ""
    }

    /// Supplies an authentication-factor code to the active authentication attempt.
    ///
    /// - Parameter input: The authentication-factor code.
    public func receiveCodeFromUser(_ input: String) {
        codeContinuation.yield(input)
    }
}

extension AppPasswordSessionManaging {

    public func createAccount(
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
        do {
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

            guard let didDocument = self.convertDIDDocument(response.didDocument) else {
                throw DIDDocument.DIDDocumentError.emptyArray
            }

            let atService = try didDocument.checkServiceForATProto()
            let serviceEndpoint = atService.serviceEndpoint

            let userSession = UserSession(
                handle: response.handle,
                sessionDID: response.did,
                email: email,
                isEmailConfirmed: nil,
                isEmailAuthenticationFactorEnabled: nil,
                didDocument: didDocument,
                isActive: nil,
                status: nil,
                serviceEndpoint: serviceEndpoint,
                pdsURL: self.pdsURL
            )

            try await keychainProtocol.saveAccessToken(response.accessToken)
            try await keychainProtocol.saveRefreshToken(response.refreshToken)

            if let password {
                try await keychainProtocol.savePassword(password)
            }

            await UserSessionRegistry.shared.register(instanceUUID, session: userSession)
        } catch {
            throw error
        }
    }

    public func authenticate(with handle: String, password: String) async throws {
        var response: ComAtprotoLexicon.Server.CreateSessionOutput? = nil
        var userCode: String? = nil
        let maxTwoFactorAuthenticationAttempts = 3
        var twoFactorAuthenticationAttempts = 0

        guard let _pdsURL = URL(string: pdsURL) else {
            throw ATRequestPrepareError.emptyPDSURL
        }

        // Loop until an error has been thrown, or until the response has been added.
        while response == nil {
            do {
                response = try await ATProtoKit(
                    apiClientConfiguration: .init(urlSessionConfiguration: configuration),
                    pdsURL: self.pdsURL,
                    canUseBlueskyRecords: false
                ).createSession(
                    with: handle,
                    and: password,
                    authenticationFactorToken: userCode
                )
            } catch let error as ATAPIError {
                switch error {
                    case .badRequest(error: let responseError):
                        if responseError.error == "AuthFactorTokenRequired" {
                            twoFactorAuthenticationAttempts += 1
                            if twoFactorAuthenticationAttempts > maxTwoFactorAuthenticationAttempts {
                                throw ATAPIError.badRequest(error: APIClientService.ATHTTPResponseError(
                                    error: "TooManyTwoFactorAuthenticationAttempts",
                                    message: "Too many invalid two-factor authentication codes. Please try again later."
                                ))
                            }

                            // Ask the user for a new code, then continue the loop.
                            userCode = await waitForUserCode()
                            continue
                        } else {
                            throw error
                        }
                    case .unauthorized(error: let responseError, wwwAuthenticate: _):
                        // Handle 2FA requirement that comes as unauthorized instead of badRequest
                        if responseError.error == "AuthFactorTokenRequired" {
                            twoFactorAuthenticationAttempts += 1
                            if twoFactorAuthenticationAttempts > maxTwoFactorAuthenticationAttempts {
                                throw ATAPIError.badRequest(error: APIClientService.ATHTTPResponseError(
                                    error: "TooManyTwoFactorAuthenticationAttempts",
                                    message: "Too many invalid two-factor authentication codes. Please try again later."
                                ))
                            }

                            // Ask the user for a new code, then continue the loop.
                            userCode = await waitForUserCode()
                            continue
                        } else {
                            throw error
                        }
                    default:
                        throw error
                }
            } catch {
                throw error
            }
        }

        // Assemble the UserSession object and insert it to the keychain protocol.
        do {
            guard let response = response else {
                // TODO: Replace with a better error.
                throw DIDDocument.DIDDocumentError.emptyArray
            }

            let convertedDIDDocument = self.convertDIDDocument(response.didDocument)

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
                didDocument: convertedDIDDocument,
                isActive: response.isActive,
                status: status,
                serviceEndpoint: try convertedDIDDocument?.checkServiceForATProto().serviceEndpoint ?? _pdsURL,
                pdsURL: self.pdsURL
            )

            try await keychainProtocol.saveAccessToken(response.accessToken)
            try await keychainProtocol.saveRefreshToken(response.refreshToken)
            try await keychainProtocol.savePassword(password)

            await UserSessionRegistry.shared.register(instanceUUID, session: userSession)
        } catch {
            throw error
        }
    }

    public func registerSession() async throws {
        let accessToken: String

        guard let _pdsURL = URL(string: pdsURL) else {
            throw ATRequestPrepareError.emptyPDSURL
        }

        do {
            accessToken = try await keychainProtocol.retrieveAccessToken()
        } catch {
            throw ATProtocolConfiguration.ATProtocolConfigurationError.noSessionToken(message: "The access token doesn't exist.")
        }

        do {
            if try SessionToken(sessionToken: accessToken).payload.expiresAt.addingTimeInterval(10) <= Date() {
                try await self.refreshSession()
            }
        } catch {
            throw error
        }

        do {
            let response = try await ATProtoKit(apiClientConfiguration: .init(urlSessionConfiguration: configuration), pdsURL: self.pdsURL, canUseBlueskyRecords: false)
                .getSession(
                    by: accessToken
                )

            let convertedDIDDocument = self.convertDIDDocument(response.didDocument)

            let didDocument = convertedDIDDocument

            let atService = try didDocument?.checkServiceForATProto()
            let serviceEndpoint = atService?.serviceEndpoint

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

            let updatedUserSession = UserSession(
                handle: response.handle,
                sessionDID: response.did,
                email: response.email,
                isEmailConfirmed: response.isEmailConfirmed,
                isEmailAuthenticationFactorEnabled: response.isEmailAuthenticationFactor,
                didDocument: didDocument,
                isActive: response.isActive,
                status: status,
                serviceEndpoint: serviceEndpoint ?? _pdsURL,
                pdsURL: self.pdsURL
            )

            _ = await UserSessionRegistry.shared.register(instanceUUID, session: updatedUserSession)
        } catch {
            throw error
        }
    }

    public func refreshSession() async throws {
        let refreshToken: String

        guard let _pdsURL = URL(string: pdsURL) else {
            throw ATRequestPrepareError.emptyPDSURL
        }

        do {
            refreshToken = try await keychainProtocol.retrieveRefreshToken()
        } catch {
            throw ATProtocolConfiguration.ATProtocolConfigurationError.noSessionToken(message: "The access token doesn't exist.")
        }

        do {
            if try SessionToken(sessionToken: refreshToken).payload.expiresAt.addingTimeInterval(10) <= Date() {
                guard let handle = await UserSessionRegistry.shared.getSession(for: instanceUUID)?.handle else {
                    // TODO: Create a better error.
                    throw DIDDocument.DIDDocumentError.emptyArray
                }

                try await self.authenticate(
                    with: handle,
                    password: try keychainProtocol.retrievePassword()
                )
            }
        } catch {
            throw error
        }

        do {
            let response = try await ATProtoKit(apiClientConfiguration: .init(urlSessionConfiguration: configuration), pdsURL: self.pdsURL, canUseBlueskyRecords: false)
                .refreshSession(
                    refreshToken: refreshToken
                )

            let convertedDIDDocument = self.convertDIDDocument(response.didDocument)

            let didDocument = convertedDIDDocument

            let atService = try didDocument?.checkServiceForATProto()
            let serviceEndpoint = atService?.serviceEndpoint

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

            let oldUserSession = await UserSessionRegistry.shared.getSession(for: instanceUUID)

            let updatedUserSession = UserSession(
                handle: response.handle,
                sessionDID: response.did,
                email: oldUserSession?.email,
                isEmailConfirmed: oldUserSession?.isEmailConfirmed,
                isEmailAuthenticationFactorEnabled: oldUserSession?.isEmailAuthenticationFactorEnabled,
                didDocument: didDocument,
                isActive: response.isActive,
                status: status,
                serviceEndpoint: serviceEndpoint ?? _pdsURL,
                pdsURL: self.pdsURL
            )

            try await keychainProtocol.saveAccessToken(response.accessToken)
            try await keychainProtocol.saveRefreshToken(response.refreshToken)

            _ = await UserSessionRegistry.shared.register(instanceUUID, session: updatedUserSession)
        } catch {
            throw error
        }
    }

    public func removeSession() async throws {
        let refreshToken: String

        do {
            refreshToken = try await keychainProtocol.retrieveRefreshToken()
        } catch {
            throw ATProtocolConfiguration.ATProtocolConfigurationError.noSessionToken(message: "The access token doesn't exist.")
        }

        do {
            if try SessionToken(sessionToken: refreshToken).payload.expiresAt.addingTimeInterval(10) <= Date() {
                guard let handle = await UserSessionRegistry.shared.getSession(for: instanceUUID)?.handle else {
                    // TODO: Create a better error.
                    throw DIDDocument.DIDDocumentError.emptyArray
                }

                try await self.authenticate(
                    with: handle,
                    password: try keychainProtocol.retrievePassword()
                )
            }
        } catch {
            throw error
        }

        do {
            try await ATProtoKit(apiClientConfiguration: .init(urlSessionConfiguration: configuration), pdsURL: self.pdsURL, canUseBlueskyRecords: false)
                .deleteSession(
                    refreshToken: refreshToken
                )

            await UserSessionRegistry.shared.removeSession(for: instanceUUID)
        } catch {
            throw error
        }
    }

    /// Converts the DID document from an ``UnknownType`` object to a ``DIDDocument`` object.
    ///
    /// - Parameter didDocument: The DID document as an ``UnknownType`` object. Optional.
    /// Defaults to `nil`.
    /// - Returns: A ``DIDDocument`` object (if there's a value) or `nil` (if not).
    public func convertDIDDocument(_ didDocument: UnknownType? = nil) -> DIDDocument? {
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

    public func ensureValidToken() async throws {
        let accessToken = try await keychainProtocol.retrieveAccessToken()

        do {
            if try SessionToken(sessionToken: accessToken).payload.expiresAt.addingTimeInterval(10) <= Date() {
                try await self.refreshSession()
            }
        } catch {
            // If we can't parse the token, continue with the original token
            // The API call will fail with proper error if token is invalid
        }
    }

    /// Creates bearer-token authorization for requests that already ask for authentication.
    ///
    /// - Parameter request: The request that needs authorization.
    /// - Returns: Bearer-token authorization, or `nil` when the request has no `Authorization` header.
    ///
    /// - Throws: An error if the token cannot be refreshed or retrieved.
    public func authorization(for request: URLRequest) async throws -> SessionAuthorization? {
        guard request.value(forHTTPHeaderField: "Authorization") != nil else {
            return nil
        }

        try await ensureValidToken()
        let accessToken = try await keychainProtocol.retrieveAccessToken()
        return .bearer(accessToken)
    }

    /// Applies session authorization to a request.
    ///
    /// - Parameters:
    ///   - request: The request to authenticate.
    ///   - authorizationRequirement: Indicates whether the request requires session authorization.
    /// - Returns: A copy of the request with authorization headers applied, or the original request
    /// if no authorization is needed.
    ///
    /// - Throws: An error if authorization cannot be prepared.
    public func authenticatedRequest(
        for request: URLRequest,
        authorizationRequirement: ATRequestAuthorizationRequirement
    ) async throws -> URLRequest {
        guard authorizationRequirement == .session else {
            return request
        }

        try await ensureValidToken()
        let accessToken = try await keychainProtocol.retrieveAccessToken()
        let authorization = SessionAuthorization.bearer(accessToken)

        var authenticatedRequest = request
        authenticatedRequest.setValue(authorization.authorizationValue, forHTTPHeaderField: "Authorization")

        for (field, value) in authorization.additionalHeaders {
            authenticatedRequest.setValue(value, forHTTPHeaderField: field)
        }

        return authenticatedRequest
    }
}

extension AppPasswordSessionManaging {

    /// Loads and registers the current App Password session.
    ///
    /// - Throws: An error if the session cannot be loaded or registered.
    @available(*, deprecated, renamed: "registerSession()")
    public func getSession() async throws {
        return try await registerSession()
    }

    /// Removes the current App Password session.
    ///
    /// - Throws: An error if the remote or local session cannot be removed.
    @available(*, deprecated, renamed: "removeSession()")
    public func deleteSession() async throws {
        return try await removeSession()
    }
}
