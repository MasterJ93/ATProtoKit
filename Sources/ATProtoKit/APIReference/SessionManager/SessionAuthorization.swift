//
//  SessionAuthorization.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2026-07-01.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Applies session authorization to requests before they are sent.
public protocol ATRequestAuthenticator: Sendable {

    /// Returns an authenticated copy of a request.
    ///
    /// - Parameter request: The request to authenticate.
    /// - Returns: An authenticated request.
    ///
    /// - Throws: An error if authorization cannot be prepared.
    func authenticatedRequest(for request: URLRequest) async throws -> URLRequest
}

/// Describes an authorization value and related headers for an AT Protocol request.
public struct SessionAuthorization: Sendable, Equatable {

    /// The value to place in the `Authorization` header.
    public let authorizationValue: String

    /// Additional authorization-related headers, such as `DPoP`.
    public let additionalHeaders: [String: String]

    /// Creates a session authorization value.
    ///
    /// - Parameters:
    ///   - authorizationValue: The value to place in the `Authorization` header.
    ///   - additionalHeaders: Additional authorization-related headers. Defaults to an empty dictionary.
    public init(
        authorizationValue: String,
        additionalHeaders: [String: String] = [:]
    ) {
        self.authorizationValue = authorizationValue
        self.additionalHeaders = additionalHeaders
    }

    /// Creates bearer-token authorization.
    ///
    /// - Parameter token: The bearer token.
    /// - Returns: A ``SessionAuthorization`` value using the `Bearer` scheme.
    public static func bearer(_ token: String) -> SessionAuthorization {
        return SessionAuthorization(authorizationValue: "Bearer \(token)")
    }

    /// Creates DPoP-token authorization.
    ///
    /// - Parameters:
    ///   - token: The DPoP-bound access token.
    ///   - proof: The DPoP proof for the request.
    /// - Returns: A ``SessionAuthorization`` value using the `DPoP` scheme and `DPoP` proof header.
    public static func dpop(token: String, proof: String) -> SessionAuthorization {
        return SessionAuthorization(
            authorizationValue: "DPoP \(token)",
            additionalHeaders: ["DPoP": proof]
        )
    }
}

/// Describes the AT Protocol identity and service endpoint made visible to ATProtoKit.
public struct SessionAuthorizationContext: Sendable, Equatable {

    /// The authenticated account's decentralized identifier.
    public let sessionDID: String

    /// The authenticated account's handle, if the authorization provider has one. Optional.
    public let handle: String?

    /// The Personal Data Server endpoint that should receive authenticated XRPC requests.
    public let serviceEndpoint: URL

    /// Creates an authorization context for an externally managed session.
    ///
    /// - Parameters:
    ///   - sessionDID: The authenticated account's decentralized identifier.
    ///   - handle: The authenticated account's handle, if the authorization provider has one. Optional.
    ///   Defaults to `nil`.
    ///   - serviceEndpoint: The Personal Data Server endpoint for authenticated XRPC requests.
    public init(sessionDID: String, handle: String? = nil, serviceEndpoint: URL) {
        self.sessionDID = sessionDID
        self.handle = handle
        self.serviceEndpoint = serviceEndpoint
    }

    /// Creates a ``UserSession`` that can be registered with ``UserSessionRegistry``.
    ///
    /// - Returns: A user session containing the identity and service endpoint.
    public func userSession() -> UserSession {
        return UserSession(
            handle: handle ?? sessionDID,
            sessionDID: sessionDID,
            isEmailAuthenticationFactorEnabled: nil,
            isActive: nil,
            status: nil,
            serviceEndpoint: serviceEndpoint,
            pdsURL: serviceEndpoint.absoluteString
        )
    }
}
