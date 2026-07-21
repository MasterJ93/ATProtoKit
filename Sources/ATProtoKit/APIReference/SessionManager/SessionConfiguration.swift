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

/// Defines the request-time requirements shared by all ATProtoKit session configurations.
///
/// Authentication mechanisms add focused capability protocols for their lifecycle operations.
/// App Password configurations use ``AppPasswordAuthenticating``,
/// ``AppPasswordCredentialStoring``, and ``ATAccountCreating``. OAuth bridges use
/// ``OAuthSessionSynchronizing``. Configurations that publish sessions to ATProtoKit also use
/// ``UserSessionRegistryManaging``.
public protocol SessionConfiguration: AnyObject, ATRequestAuthenticator, Sendable {

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

    /// An executor that lets an OAuth implementation send the complete authenticated request. Optional.
    ///
    /// Use this integration point when the OAuth implementation must own token refresh, DPoP proof
    /// generation, nonce retries, and transport. Header-based implementations can leave this property
    /// as `nil` and implement ``authorization(for:)`` instead.
    var requestExecutor: ATRequestExecutor? { get }

    /// Indicates whether the request executor owns authorization as well as transport.
    var requestExecutorOwnsAuthorization: Bool { get }

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

    /// Creates an authorization value for a request.
    ///
    /// - Parameter request: The request that needs authorization.
    /// - Returns: The authorization value to apply, or `nil` when the request should remain unchanged.
    ///
    /// - Throws: An error if authorization cannot be prepared.
    func authorization(for request: URLRequest) async throws -> SessionAuthorization?

    /// Returns the identity and PDS endpoint currently visible to ATProtoKit.
    ///
    /// - Returns: The active authorization context if the session is available, or `nil` if not.
    ///
    /// - Throws: An error if the context cannot be loaded.
    func authorizationContext() async throws -> SessionAuthorizationContext?
}

extension SessionConfiguration {

    public var requestExecutor: ATRequestExecutor? {
        return nil
    }

    public var requestExecutorOwnsAuthorization: Bool {
        return false
    }

    public func authenticatedRequest(
        for request: URLRequest,
        authorizationRequirement: ATRequestAuthorizationRequirement
    ) async throws -> URLRequest {
        guard authorizationRequirement == .session,
              let authorization = try await authorization(for: request) else {
            return request
        }

        var authenticatedRequest = request

        authenticatedRequest.setValue(authorization.authorizationValue, forHTTPHeaderField: "Authorization")

        for (field, value) in authorization.additionalHeaders {
            authenticatedRequest.setValue(value, forHTTPHeaderField: field)
        }

        return authenticatedRequest
    }

    public func authorizationContext() async throws -> SessionAuthorizationContext? {
        guard let session = await UserSessionRegistry.shared.getSession(for: instanceUUID) else {
            return nil
        }

        return SessionAuthorizationContext(
            sessionDID: session.sessionDID,
            handle: session.handle,
            serviceEndpoint: session.serviceEndpoint
        )
    }
}
