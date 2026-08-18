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

/// Persists the App Password and refresh token used by an App Password session.
public protocol AppPasswordCredentialStoring: SessionConfiguration {

    /// The secure store containing the App Password and refresh token.
    var credentialStore: ATCredentialStore { get }

    /// Retrieves the persisted refresh token for the App Password session. Optional.
    ///
    /// - Returns: The stored refresh token, or `nil` when no refresh token exists. Optional.
    ///
    /// - Throws: ``ATCredentialStoreError/invalidStringData`` or an error from the credential
    ///   store.
    func storedRefreshToken() async throws -> String?
}

extension AppPasswordCredentialStoring {

    /// Retrieves the persisted refresh token for the App Password session. Optional.
    ///
    /// - Returns: The stored refresh token, or `nil` when no refresh token exists. Optional.
    ///
    /// - Throws: ``ATCredentialStoreError/invalidStringData`` or an error from the credential
    ///   store.
    public func storedRefreshToken() async throws -> String? {
        let key = credentialKey(suffix: "refreshToken")
        return try await loadCredential(forKey: key)
    }

    /// Saves an App Password credential.
    ///
    /// - Parameter password: The App Password to save.
    ///
    /// - Throws: An error from the credential store.
    internal func savePasswordCredential(_ password: String) async throws {
        try await saveCredential(password, suffix: "password")
    }

    /// Retrieves an App Password credential.
    ///
    /// - Returns: The stored App Password.
    ///
    /// - Throws: ``ATCredentialStoreError`` or an error from the credential store.
    internal func retrievePasswordCredential() async throws -> String {
        let key = credentialKey(suffix: "password")
        guard let value = try await loadCredential(forKey: key) else {
            throw ATCredentialStoreError.valueNotFound(key: key)
        }

        return value
    }

    /// Saves an App Password refresh token.
    ///
    /// - Parameter refreshToken: The refresh token to save.
    ///
    /// - Throws: An error from the credential store.
    internal func saveRefreshTokenCredential(_ refreshToken: String) async throws {
        try await saveCredential(refreshToken, suffix: "refreshToken")
    }

    /// Retrieves an App Password refresh token.
    ///
    /// - Returns: The stored refresh token.
    ///
    /// - Throws: ``ATCredentialStoreError`` or an error from the credential store.
    internal func retrieveRefreshTokenCredential() async throws -> String {
        let key = credentialKey(suffix: "refreshToken")
        guard let value = try await storedRefreshToken() else {
            throw ATCredentialStoreError.valueNotFound(key: key)
        }

        return value
    }

    /// Deletes the persisted App Password credential.
    ///
    /// - Throws: An error from the credential store.
    internal func deletePasswordCredential() async throws {
        try await credentialStore.deleteValue(forKey: credentialKey(suffix: "password"))
    }

    /// Deletes the persisted App Password refresh token.
    ///
    /// - Throws: An error from the credential store.
    internal func deleteRefreshTokenCredential() async throws {
        try await credentialStore.deleteValue(forKey: credentialKey(suffix: "refreshToken"))
    }

    /// Creates an account-specific storage key.
    ///
    /// - Parameter suffix: The credential kind suffix.
    /// - Returns: A storage key namespaced to this session.
    private func credentialKey(suffix: String) -> String {
        return "\(instanceUUID.uuidString).\(suffix)"
    }

    /// Loads and decodes a stored credential. Optional.
    ///
    /// - Parameter key: The credential's storage key.
    /// - Returns: The decoded credential, or `nil` when it does not exist. Optional.
    ///
    /// - Throws: ``ATCredentialStoreError/invalidStringData`` or an error from the credential
    ///   store.
    private func loadCredential(forKey key: String) async throws -> String? {
        guard let data = try await credentialStore.loadValue(forKey: key) else {
            return nil
        }
        guard let value = String(data: data, encoding: .utf8) else {
            throw ATCredentialStoreError.invalidStringData
        }

        return value
    }

    /// Encodes and saves a credential.
    ///
    /// - Parameters:
    ///   - value: The credential to save.
    ///   - suffix: The credential kind suffix.
    ///
    /// - Throws: An error from the credential store.
    private func saveCredential(_ value: String, suffix: String) async throws {
        try await credentialStore.saveValue(
            Data(value.utf8),
            forKey: credentialKey(suffix: suffix)
        )
    }
}

/// Authenticates and maintains a legacy App Password session.
public protocol AppPasswordAuthenticating: AppPasswordCredentialStoring {

    /// The stream that receives user-provided authentication-factor codes.
    var codeStream: AsyncStream<String> { get }

    /// The continuation that supplies authentication-factor codes to ``codeStream``.
    var codeContinuation: AsyncStream<String>.Continuation { get }

    /// Replaces the short-lived App Password access token held in memory.
    ///
    /// - Parameter accessToken: The access token to cache.
    func cacheAccessToken(_ accessToken: String) async

    /// Retrieves the short-lived App Password access token held in memory. Optional.
    ///
    /// - Returns: The cached access token. Optional.
    func cachedAccessToken() async -> String?

    /// Removes the short-lived App Password access token held in memory.
    func clearCachedAccessToken() async

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

    /// Retrieves the cached access token or reports that the session must be refreshed.
    ///
    /// - Returns: The cached access token.
    ///
    /// - Throws: ``ATProtocolConfiguration/ATProtocolConfigurationError/noSessionToken(message:)``
    ///   when no access token is cached.
    internal func requireCachedAccessToken() async throws -> String {
        guard let accessToken = await cachedAccessToken() else {
            throw ATProtocolConfiguration.ATProtocolConfigurationError.noSessionToken(
                message: "The access token is not available in memory."
            )
        }

        return accessToken
    }

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

            await cacheAccessToken(response.accessToken)
            try await saveRefreshTokenCredential(response.refreshToken)

            if let password {
                try await savePasswordCredential(password)
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

            await cacheAccessToken(response.accessToken)
            try await saveRefreshTokenCredential(response.refreshToken)
            try await savePasswordCredential(password)

            await UserSessionRegistry.shared.register(instanceUUID, session: userSession)
        } catch {
            throw error
        }
    }

    public func registerSession() async throws {
        guard let _pdsURL = URL(string: pdsURL) else {
            throw ATRequestPrepareError.emptyPDSURL
        }

        try await ensureValidToken()

        do {
            let client = await ATProtoKit(
                sessionConfiguration: self,
                apiClientConfiguration: .init(urlSessionConfiguration: configuration),
                pdsURL: self.pdsURL,
                canUseBlueskyRecords: false
            )
            let response = try await client.getSession()

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
            refreshToken = try await retrieveRefreshTokenCredential()
        } catch {
            throw ATProtocolConfiguration.ATProtocolConfigurationError.noSessionToken(message: "The refresh token doesn't exist.")
        }

        do {
            if try SessionToken(sessionToken: refreshToken).payload.expiresAt.addingTimeInterval(10) <= Date() {
                guard let handle = await UserSessionRegistry.shared.getSession(for: instanceUUID)?.handle else {
                    // TODO: Create a better error.
                    throw DIDDocument.DIDDocumentError.emptyArray
                }

                try await self.authenticate(
                    with: handle,
                    password: try await retrievePasswordCredential()
                )
                return
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

            await cacheAccessToken(response.accessToken)
            try await saveRefreshTokenCredential(response.refreshToken)

            _ = await UserSessionRegistry.shared.register(instanceUUID, session: updatedUserSession)
        } catch {
            throw error
        }
    }

    public func removeSession() async throws {
        var refreshToken: String

        do {
            refreshToken = try await retrieveRefreshTokenCredential()
        } catch {
            throw ATProtocolConfiguration.ATProtocolConfigurationError.noSessionToken(message: "The refresh token doesn't exist.")
        }

        do {
            if try SessionToken(sessionToken: refreshToken).payload.expiresAt.addingTimeInterval(10) <= Date() {
                guard let handle = await UserSessionRegistry.shared.getSession(for: instanceUUID)?.handle else {
                    // TODO: Create a better error.
                    throw DIDDocument.DIDDocumentError.emptyArray
                }

                try await self.authenticate(
                    with: handle,
                    password: try await retrievePasswordCredential()
                )
                refreshToken = try await retrieveRefreshTokenCredential()
            }
        } catch {
            throw error
        }

        do {
            try await ATProtoKit(apiClientConfiguration: .init(urlSessionConfiguration: configuration), pdsURL: self.pdsURL, canUseBlueskyRecords: false)
                .deleteSession(
                    refreshToken: refreshToken
                )

            await clearCachedAccessToken()
            try await deleteRefreshTokenCredential()
            try await deletePasswordCredential()
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
        guard let accessToken = await cachedAccessToken() else {
            try await refreshSession()
            _ = try await requireCachedAccessToken()
            return
        }

        let expirationDate: Date
        do {
            expirationDate = try SessionToken(sessionToken: accessToken).payload.expiresAt
        } catch is SessionToken.SessionTokenError {
            return
        }

        if expirationDate.addingTimeInterval(10) <= Date() {
            try await self.refreshSession()
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
        let accessToken = try await requireCachedAccessToken()
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
        let accessToken = try await requireCachedAccessToken()
        let authorization = SessionAuthorization.bearer(accessToken)

        var authenticatedRequest = request
        authenticatedRequest.setValue(authorization.authorizationValue, forHTTPHeaderField: "Authorization")

        for (field, value) in authorization.additionalHeaders {
            authenticatedRequest.setValue(value, forHTTPHeaderField: field)
        }

        return authenticatedRequest
    }
}
