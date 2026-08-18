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
/// Use this configuration when your app depends on an OAuth package that owns authentication,
/// authorization, refresh, DPoP nonce handling, retries, and transport. ATProtoKit receives the
/// authenticated identity, Personal Data Server (PDS) endpoint, and completed network responses.
final public class ATOAuthSessionConfiguration: SessionConfiguration, OAuthSessionSynchronizing {

    /// The base URL of the Personal Data Server (PDS) used before a session context is loaded.
    public let pdsURL: String

    /// The URL session configuration used by ATProtoKit.
    public let configuration: URLSessionConfiguration

    /// The unique identifier used to register the visible user session.
    public let instanceUUID: UUID

    /// The executor that lets the OAuth package authorize and send complete requests.
    public let requestExecutor: ATRequestExecutor?

    /// Indicates whether the configured executor owns authorization.
    public var requestExecutorOwnsAuthorization: Bool {
        return true
    }

    /// The closure that loads the externally managed session context.
    ///
    /// - Returns: A instance that loads the externally managed session context.
    private let contextProvider: @Sendable () async throws -> SessionAuthorizationContext?

    /// The closure that explicitly refreshes the externally managed session.
    private let refreshHandler: (@Sendable () async throws -> SessionAuthorizationContext?)?

    /// The closure that deletes the externally managed OAuth session.
    private let deletionHandler: @Sendable () async throws -> Void

    /// The complete authorization context most recently loaded from the OAuth provider.
    private let authorizationContextStore = ATOAuthAuthorizationContextStore()

    /// Creates an instance of `ATOAuthSessionConfiguration`, as an external OAuth
    /// session configuration.
    ///
    /// - Parameters:
    ///   - pdsURL: The base URL of the Personal Data Server (PDS) used before a session context is loaded.
    ///   - configuration: The URL session configuration used by ATProtoKit. Defaults to `.default`.
    ///   - instanceUUID: The unique identifier used to register the visible user session. Defaults to
    ///   a newly generated identifier.
    ///   - requestExecutor: The OAuth-aware executor responsible for authorization, refresh, DPoP
    ///   nonce handling, retries, and transport.
    ///   - contextProvider: The closure that loads the externally managed session context.
    ///   - refreshHandler: The closure that performs an explicit OAuth refresh. Optional.
    ///   - deletionHandler: The closure that deletes the externally managed OAuth session. Defaults
    ///   to a closure that performs no work.
    public init(
        pdsURL: String,
        configuration: URLSessionConfiguration = .default,
        instanceUUID: UUID = UUID(),
        requestExecutor: ATRequestExecutor,
        contextProvider: @escaping @Sendable () async throws -> SessionAuthorizationContext?,
        refreshHandler: (@Sendable () async throws -> SessionAuthorizationContext?)? = nil,
        deletionHandler: @escaping @Sendable () async throws -> Void = {}
    ) {
        self.pdsURL = pdsURL
        self.configuration = configuration
        self.instanceUUID = instanceUUID
        self.requestExecutor = requestExecutor
        self.contextProvider = contextProvider
        self.refreshHandler = refreshHandler
        self.deletionHandler = deletionHandler
    }

    /// Creates an instance of `ATOAuthSessionConfiguration`, making an external OAuth session configuration
    /// from a fixed authorization context.
    ///
    /// Use this initializer when the authenticated identity, service endpoint, and granted
    /// scopes remain unchanged for the lifetime of the configuration.
    ///
    /// - Parameters:
    ///   - context: The fixed external OAuth authorization context.
    ///   - configuration: The URL session configuration used by ATProtoKit. Defaults to `.default`.
    ///   - instanceUUID: The unique session-registration identifier. Defaults to a newly generated identifier.
    ///   - requestExecutor: The external OAuth request executor.
    ///   - deletionHandler: The operation that deletes the external OAuth session. Defaults to an operation
    ///     that performs no work.
    public convenience init(
        context: SessionAuthorizationContext,
        configuration: URLSessionConfiguration = .default,
        instanceUUID: UUID = UUID(),
        requestExecutor: ATRequestExecutor,
        deletionHandler: @escaping @Sendable () async throws -> Void = {}
    ) {
        self.init(
            pdsURL: context.serviceEndpoint.absoluteString,
            configuration: configuration,
            instanceUUID: instanceUUID,
            requestExecutor: requestExecutor,
            contextProvider: {
                return context
            },
            deletionHandler: deletionHandler
        )
    }

    /// Registers the current externally managed OAuth session with ATProtoKit.
    ///
    /// - Throws: An error if the external provider cannot load a session context.
    public func registerSession() async throws {
        guard let context = try await contextProvider() else {
            throw ATProtocolConfiguration.ATProtocolConfigurationError.noSessionToken(
                message: "The external OAuth provider did not return a session context."
            )
        }

        try context.validate()
        await authorizationContextStore.set(context)
        await UserSessionRegistry.shared.register(instanceUUID, session: context.userSession())
    }

    /// Reloads and registers the externally managed session.
    ///
    /// - Throws: An error if the external provider cannot load a refreshed session context.
    public func synchronizeSession() async throws {
        let context: SessionAuthorizationContext?
        if let refreshHandler {
            context = try await refreshHandler()
        } else {
            context = try await contextProvider()
        }
        guard let context else {
            throw ATProtocolConfiguration.ATProtocolConfigurationError.noSessionToken(
                message: "The external OAuth synchronization operation did not return a session context."
            )
        }
        try context.validate()
        await authorizationContextStore.set(context)
        await UserSessionRegistry.shared.register(instanceUUID, session: context.userSession())
    }

    /// Deletes the externally managed session and removes it from ATProtoKit's registry.
    ///
    /// - Throws: An error if the external deletion handler fails.
    public func removeSession() async throws {
        try await deletionHandler()
        await authorizationContextStore.set(nil)
        await UserSessionRegistry.shared.removeSession(for: instanceUUID)
    }

    /// Returns no header-only authorization because the OAuth-aware executor owns authorization.
    ///
    /// - Parameter request: The request that needs authorization.
    /// - Returns: Always `nil`; authorization is applied by ``requestExecutor``.
    public func authorization(for request: URLRequest) async throws -> SessionAuthorization? {
        return nil
    }

    /// Returns the complete externally managed authorization context.
    ///
    /// - Returns: The most recently loaded authorization context, including its exact granted scopes.
    ///
    /// - Throws: An error if the external provider cannot load the context.
    public func authorizationContext() async throws -> SessionAuthorizationContext? {
        if let context = await authorizationContextStore.get() {
            return context
        }

        return try await contextProvider()
    }
}

extension ATOAuthSessionConfiguration {

    /// Registers the externally managed OAuth session with ATProtoKit.
    ///
    /// - Throws: An error if the external context cannot be loaded or registered.
    @available(*, deprecated, renamed: "registerSession()")
    public func getSession() async throws {
        return try await registerSession()
    }

    /// Explicitly refreshes the external OAuth session and synchronizes its context.
    ///
    /// Normal request-time refresh remains the responsibility of the OAuth executor.
    ///
    /// - Throws: An error if no explicit refresh handler exists or refresh fails.
    @available(*, deprecated, renamed: "synchronizeSession()")
    public func refreshSession() async throws {
        guard refreshHandler != nil else {
            throw ATOAuthSessionConfigurationError.missingRefreshHandler
        }
        return try await synchronizeSession()
    }

    /// Removes the externally managed OAuth session from ATProtoKit.
    ///
    /// - Throws: An error if the external session cannot be removed.
    @available(*, deprecated, renamed: "removeSession()")
    public func deleteSession() async throws {
        return try await removeSession()
    }
}

/// Stores the latest externally managed OAuth authorization context safely across tasks.
private actor ATOAuthAuthorizationContextStore {

    /// The latest authorization context supplied by the external OAuth provider. Optional.
    private var context: SessionAuthorizationContext?

    /// Returns the stored authorization context.
    ///
    /// - Returns: The latest authorization context, or `nil` when none has been stored.
    internal func get() -> SessionAuthorizationContext? {
        return context
    }

    /// Replaces the stored authorization context.
    ///
    /// - Parameter context: The authorization context to store. Optional.
    internal func set(_ context: SessionAuthorizationContext?) {
        self.context = context
    }
}
