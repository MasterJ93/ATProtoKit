//
//  SessionConfiguration.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Defines the requirements for session configurations within ATProtoKit.
///
/// This protocol contains default implementations for the methods used. You can choose
/// to use those implementations, or create your own.
///
/// When implementing this protocol onto your `class`, you should keep in mind of a few things:
/// - `class`es that conform to `SessionConfiguration` must be marked `final` and
/// adopt `Sendable`.
/// - You should use `UserSessionRegistry` to manage ``UserSession`` instances.
/// - When deleting a session, make sure that `deleteSession` removes the instance
/// from `UserSessionRegistry`.
/// - Accessing the access token, refresh token, or password requires
/// using `KeychainProtocol`.
public protocol SessionConfiguration: AnyObject, Sendable {

    /// The base URL of the Personal Data Server (PDS) with which the AT Protocol interacts.
    ///
    /// This URL is used to make network requests to the PDS for various operations, such as
    /// session creation, refresh, and deletion.
    var pdsURL: String { get }

    /// An instance of `URLSessionConfiguration`.
    var configuration: URLSessionConfiguration { get }

    /// A `UUID` object specific to the `UserSession` instance.
    ///
    /// This is used to look for the `UserSession` instance within `UserSessionRegistry`.
    var instanceUUID: UUID { get }

    /// The async stream that receives user-provided authentication codes.
    ///
    /// This stream should be awaited by conforming types to receive
    /// user input asynchronously during the authentication process.
    var codeStream: AsyncStream<String> { get }

    /// The continuation used to yield new user input into the `codeStream`.
    ///
    /// Conforming types should call `codeContinuation.yield(_:)` to
    /// provide new authentication codes from the user.
    var codeContinuation: AsyncStream<String>.Continuation { get }

    /// An instance of `SecureKeychainProtocol`.
    var keychainProtocol: SecureKeychainProtocol { get }

    /// A type alias for defining a closure that takes a `URLRequest` and returns a tuple of `Data`
    /// and `URLResponse`.
    ///
    /// This closure is used for customizing how network requests are executed asynchronously. It allows
    /// conforming types to specify a different implementation for sending requests and receiving responses,
    /// which can be useful for dependency injection, testing, or swapping out networking layers.
    ///
    /// - Parameters:
    ///   - URLRequest: The request to be sent.
    /// - Returns: A tuple containing the raw response `Data` and the associated `URLResponse`.
    ///
    /// - Throws: An error if the request fails or cannot be processed.
    typealias ResponseProvider = @Sendable (URLRequest) async throws -> (Data, URLResponse)

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

    /// Attempts to authenticate with the PDS.
    ///
    /// This method should implement the necessary logic to authenticate the user against the PDS,
    /// while adding the password and tokens to the `keychainProtocol` instance. Additional
    /// Two-Factor Authentication implementations must be handled as well.
    ///
    /// - Parameters:
    ///   - handle: The hanle used for the account.
    ///   - password: The password used for the account.
    ///
    /// - Throws: An error if there are issues creating the request or communicating with the PDS.
    func authenticate(with handle: String, password: String) async throws

    /// Fetches an existing session using an access token.
    ///
    /// If the access token is invalid, then a new one will be created, either by refeshing a
    /// session, or by re-authenticating.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    func getSession() async throws

    /// Refreshes the user's session using a refresh token.
    ///
    /// If the refresh token is invalid, the method will re-authenticate and try again.
    ///
    /// - Note: If the method throws an error saying that an authentication token is required,
    /// re-trying the method with the `authenticationFactorToken` argument filled should
    /// solve the issue.
    ///
    /// When the method completes, the linked ``UserSession`` inside ``UserSessionRegistry`` will
    /// be replaced with a new instance.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    func refreshSession() async throws

    /// Deletes the user session.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    func deleteSession() async throws

    /// Waits for the Two-Factor Authentication code from the user.
    ///
    /// It's best not to override this method's default implementation unless you need
    /// additional setup. If you do need to override this implementation, ensure that the following
    /// line is in your custom implementation:
    ///
    /// ```swift
    /// codeContinuation.yield(input)
    /// return await iterator.next() ?? ""
    /// ```
    ///
    /// - Returns: The code from the `codeStream`.
    func waitForUserCode() async -> String

    /// Takes the Two-Factor Authentication code inputted from the user.
    ///
    /// It's best not to override this method's default implementation unless you need
    /// additional setup. If you do need to override this implementation, ensure that the following
    /// line is in your custom implementation:
    ///
    /// ```swift
    /// var iterator = codeStream.makeAsyncIterator()
    ///
    /// ```
    ///
    /// - Parameter input: The Two-Factor Authentication code.
    func receiveCodeFromUser(_ input: String)
    
    /// Ensures the access token is valid and refreshes it if needed.
    ///
    /// This method checks if the current access token will expire within
    /// the next 10 seconds and automatically refreshes it if necessary.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type if refresh fails.
    func ensureValidToken() async throws
}

extension SessionConfiguration {

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

    public func getSession() async throws {
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

    public func waitForUserCode() async -> String {
        var iterator = codeStream.makeAsyncIterator()
        return await iterator.next() ?? ""
    }

    public func receiveCodeFromUser(_ input: String) {
        codeContinuation.yield(input)
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

    public func deleteSession() async throws {
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
}
