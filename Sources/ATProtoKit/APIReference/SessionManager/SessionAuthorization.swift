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
    /// - Parameters:
    ///   - request: The request to authenticate.
    ///   - authorizationRequirement: Indicates whether the request requires session authorization.
    /// - Returns: An authenticated request.
    ///
    /// - Throws: An error if authorization cannot be prepared.
    func authenticatedRequest(
        for request: URLRequest,
        authorizationRequirement: ATRequestAuthorizationRequirement
    ) async throws -> URLRequest
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

    /// The exact OAuth scopes granted by the authorization server.
    public let grantedScopes: Set<String>

    /// Creates an authorization context for an externally managed session.
    ///
    /// - Parameters:
    ///   - sessionDID: The authenticated account's decentralized identifier.
    ///   - handle: The authenticated account's handle, if the authorization provider has one. Optional.
    ///   Defaults to `nil`.
    ///   - serviceEndpoint: The Personal Data Server endpoint for authenticated XRPC requests.
    ///   - grantedScopes: The exact OAuth scopes granted by the authorization server. Defaults to an empty set.
    public init(
        sessionDID: String,
        handle: String? = nil,
        serviceEndpoint: URL,
        grantedScopes: Set<String> = []
    ) {
        self.sessionDID = sessionDID
        self.handle = handle
        self.serviceEndpoint = serviceEndpoint
        self.grantedScopes = grantedScopes
    }

    /// Indicates whether an exact scope was granted.
    ///
    /// - Parameter scope: The scope string to find.
    /// - Returns: `true` when the scope is present.
    public func hasGrantedScope(_ scope: String) -> Bool {
        return self.grantedScopes.contains(scope)
    }

    /// Returns the required OAuth scopes that were not granted to this session.
    ///
    /// Scope comparison is exact. AT Protocol permission wildcards and permission-set references
    /// retain their server-defined semantics and are not expanded by ATProtoKit.
    ///
    /// - Parameter requiredScopes: The exact scopes required by an operation.
    /// - Returns: The required scopes absent from ``grantedScopes``.
    public func missingGrantedScopes(from requiredScopes: Set<String>) -> Set<String> {
        return requiredScopes.subtracting(self.grantedScopes)
    }

    /// Ensures that the session grants every exact OAuth scope required by an operation.
    ///
    /// - Parameter requiredScopes: The exact scopes required by an operation.
    ///
    /// - Throws: ``ATOAuthSessionConfigurationError/insufficientScopes(scopes:)`` when one or more
    ///   required scopes were not granted.
    public func requireGrantedScopes(_ requiredScopes: Set<String>) throws {
        let missingScopes = self.missingGrantedScopes(from: requiredScopes)
        guard missingScopes.isEmpty else {
            throw ATOAuthSessionConfigurationError.insufficientScopes(scopes: missingScopes)
        }
    }

    /// Validates the identity, PDS endpoint, and mandatory profile scope supplied by an OAuth provider.
    ///
    /// - Throws: An ``ATOAuthSessionConfigurationError`` when the context cannot represent a valid
    ///   AT Protocol OAuth session.
    public func validate() throws {
        let didPattern = #"^did:[a-z0-9]+:[A-Za-z0-9._:%-]+$"#
        guard self.sessionDID.range(of: didPattern, options: .regularExpression) != nil else {
            throw ATOAuthSessionConfigurationError.invalidSessionDID(did: self.sessionDID)
        }

        guard serviceEndpoint.isValidPDSServiceEndpoint else {
            throw ATOAuthSessionConfigurationError.invalidServiceEndpoint(endpoint: serviceEndpoint)
        }

        guard grantedScopes.contains("atproto") else {
            throw ATOAuthSessionConfigurationError.missingATProtoScope
        }
    }

    /// Creates a ``UserSession`` that can be registered with ``UserSessionRegistry``.
    ///
    /// - Returns: A user session containing the identity and service endpoint.
    public func userSession() -> UserSession {
        return UserSession(
            handle: self.handle ?? self.sessionDID,
            sessionDID: self.sessionDID,
            isEmailAuthenticationFactorEnabled: nil,
            isActive: nil,
            status: nil,
            serviceEndpoint: serviceEndpoint,
            pdsURL: serviceEndpoint.absoluteString
        )
    }
}
