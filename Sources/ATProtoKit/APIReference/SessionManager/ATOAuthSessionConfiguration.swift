//
//  ATOAuthSessionConfiguration.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2026-07-03.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A bridge between ATProtoKit and an app-owned OAuth implementation.
///
/// Use this configuration when your app depends on an OAuth package and ATProtoKit should only receive
/// the authenticated identity, Personal Data Server (PDS) endpoint, and per-request authorization headers.
final public class ATOAuthSessionConfiguration: SessionConfiguration {

    /// The base URL of the Personal Data Server (PDS) used before a session context is loaded.
    public let pdsURL: String

    /// The URL session configuration used by ATProtoKit.
    public let configuration: URLSessionConfiguration

    /// The unique identifier used to register the visible user session.
    public let instanceUUID: UUID

    /// The stream used by compatibility authentication flows.
    public let codeStream: AsyncStream<String>

    /// The continuation used by compatibility authentication flows.
    public let codeContinuation: AsyncStream<String>.Continuation

    /// A presenter that can drive OAuth browser authorization and get back callback URLs. Optional.
    public let oauthAuthorizationPresenter: OAuthAuthorizationPresenting?

    /// The executor that lets the OAuth package send complete authenticated requests. Optional.
    public let requestExecutor: ATRequestExecutor?

    /// The closure that creates request authorization from the OAuth package.
    private let authorizationProvider: @Sendable (URLRequest) async throws -> SessionAuthorization?

    /// The closure that loads the externally managed session context.
    private let contextProvider: @Sendable () async throws -> SessionAuthorizationContext?

    /// The closure that deletes the externally managed OAuth session.
    private let deletionHandler: @Sendable () async throws -> Void

    /// Creates an instance of `ATOAuthSessionConfiguration`, as an external OAuth
    /// session configuration.
    ///
    /// - Parameters:
    ///   - pdsURL: The base URL of the Personal Data Server (PDS) used before a session context is loaded.
    ///   - configuration: The URL session configuration used by ATProtoKit. Defaults to `.default`.
    ///   - instanceUUID: The unique identifier used to register the visible user session. Defaults to
    ///   a newly generated identifier.
    ///   - oauthAuthorizationPresenter: A presenter that can drive OAuth browser authorization and get
    ///   back callback URLs. Optional. Defaults to `nil`.
    ///   - requestExecutor: The executor that lets the OAuth package send complete authenticated
    ///   requests. Optional. Defaults to `nil`.
    ///   - authorizationProvider: The closure that creates request authorization from the OAuth package.
    ///   Defaults to a closure that returns `nil`.
    ///   - contextProvider: The closure that loads the externally managed session context.
    ///   - deletionHandler: The closure that deletes the externally managed OAuth session. Defaults
    ///   to a closure that performs no work.
    public init(
        pdsURL: String,
        configuration: URLSessionConfiguration = .default,
        instanceUUID: UUID = UUID(),
        oauthAuthorizationPresenter: OAuthAuthorizationPresenting? = nil,
        requestExecutor: ATRequestExecutor? = nil,
        authorizationProvider: @escaping @Sendable (URLRequest) async throws -> SessionAuthorization? = { _ in nil },
        contextProvider: @escaping @Sendable () async throws -> SessionAuthorizationContext?,
        deletionHandler: @escaping @Sendable () async throws -> Void = {}
    ) {
        self.pdsURL = pdsURL
        self.configuration = configuration
        self.instanceUUID = instanceUUID
        self.oauthAuthorizationPresenter = oauthAuthorizationPresenter
        self.requestExecutor = requestExecutor
        self.authorizationProvider = authorizationProvider
        self.contextProvider = contextProvider
        self.deletionHandler = deletionHandler

        let (stream, continuation) = AsyncStream<String>.makeStream(bufferingPolicy: .bufferingNewest(1))
        self.codeStream = stream
        self.codeContinuation = continuation
    }

    /// Attempts to authenticate with a handle and password.
    ///
    /// - Parameters:
    ///   - handle: The handle used for the account.
    ///   - password: The password used for the account.
    ///
    /// - Throws: Always throws because OAuth authentication is owned by the external package.
    public func authenticate(with handle: String, password: String) async throws {
        throw ATProtocolConfiguration.ATProtocolConfigurationError.noSessionToken(
            message: "External OAuth session configurations authenticate through their OAuth package."
        )
    }

    /// Creates an account through this external OAuth session configuration.
    ///
    /// - Parameters:
    ///   - email: The email of the user. Optional.
    ///   - handle: The requested handle.
    ///   - existingDID: An existing decentralized identifier to import. Optional.
    ///   - inviteCode: The invite code for the user. Optional.
    ///   - verificationCode: A verification code. Optional.
    ///   - verificationPhone: A phone verification code. Optional.
    ///   - password: The account password. Optional.
    ///   - recoveryKey: The DID PLC recovery key. Optional.
    ///   - plcOperation: A signed DID PLC operation. Optional.
    ///
    /// - Throws: Always throws because account creation is not handled by the OAuth bridge.
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
        throw ATProtocolConfiguration.ATProtocolConfigurationError.noSessionToken(
            message: "External OAuth session configurations don't create accounts."
        )
    }

    /// Registers the current externally managed OAuth session with ATProtoKit.
    ///
    /// - Throws: An error if the external provider cannot load a session context.
    public func getSession() async throws {
        guard let context = try await contextProvider() else {
            throw ATProtocolConfiguration.ATProtocolConfigurationError.noSessionToken(
                message: "The external OAuth provider did not return a session context."
            )
        }

        await UserSessionRegistry.shared.register(instanceUUID, session: context.userSession())
    }

    /// Refreshes the externally managed session.
    ///
    /// - Throws: An error if the external provider cannot load a refreshed session context.
    public func refreshSession() async throws {
        try await getSession()
    }

    /// Deletes the externally managed session and removes it from ATProtoKit's registry.
    ///
    /// - Throws: An error if the external deletion handler fails.
    public func deleteSession() async throws {
        try await deletionHandler()
        await UserSessionRegistry.shared.removeSession(for: instanceUUID)
    }

    /// Ensures the externally managed token is valid.
    ///
    /// OAuth packages usually refresh while authorizing the outgoing request, so this method keeps
    /// ATProtoKit from imposing App Password token parsing on external OAuth sessions.
    public func ensureValidToken() async throws {
    }

    /// Waits for the next user-provided code.
    ///
    /// - Returns: The next code, or an empty string if the stream ends.
    public func waitForUserCode() async -> String {
        var iterator = codeStream.makeAsyncIterator()
        return await iterator.next() ?? ""
    }

    /// Receives a user-provided code.
    ///
    /// - Parameter input: The code received from the user.
    public func receiveCodeFromUser(_ input: String) {
        codeContinuation.yield(input)
    }

    /// Creates authorization for a request by delegating to the app-owned OAuth package.
    ///
    /// - Parameter request: The request that needs authorization.
    /// - Returns: Authorization for the outgoing request, or `nil` if none should be applied.
    ///
    /// - Throws: An error if the OAuth package cannot authorize the request.
    public func authorization(for request: URLRequest) async throws -> SessionAuthorization? {
        guard request.requiresATProtoKitAuthorization ||
              request.value(forHTTPHeaderField: "Authorization") != nil else {
            return nil
        }

        return try await authorizationProvider(request)
    }
}
