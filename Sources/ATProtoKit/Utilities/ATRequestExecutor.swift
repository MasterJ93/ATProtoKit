//
//  ATRequestExecutor.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-04-18.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Describes whether an outgoing AT Protocol request requires session authorization.
public enum ATRequestAuthorizationRequirement: Sendable, Equatable {

    /// The request is public.
    case none

    /// The request requires authorization from the active session.
    case session
}

/// An abstraction for executing network requests and returning raw data and response metadata.
///
/// This protocol enables decoupling network transport logic from higher-level API clients.
/// Implementers of this protocol are responsible for performing a given `URLRequest`
/// asynchronously, returning the resulting response data and associated metadata. This allows for
/// swapping networking layers, providing mock tests, or customizing transport strategies without
/// modifying API client logic.
public protocol ATRequestExecutor: Sendable {

    /// Executes a network request and returns the response data and metadata.
    ///
    /// This method performs the provided `URLRequest` asynchronously and returns a tuple containing the
    /// raw response `Data` and the corresponding `URLResponse` upon success. If the request fails, this
    /// method throws an error describing the failure.
    ///
    /// - Important: Implementers should not modify the provided `URLRequest`. All mutations must be
    /// performed on a copy if needed.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` to execute.
    ///   - authorizationRequirement: Indicates whether the request requires session authorization.
    /// - Returns: A tuple, containing the response body as `Data`, and the `URLResponse` metadata.
    ///
    /// - Throws: An error if the request fails, is cancelled, or if a networking error occurs.
    func execute(
        _ request: URLRequest,
        authorizationRequirement: ATRequestAuthorizationRequirement
    ) async throws -> (Data, URLResponse)
}

/// Executes requests by calling a sendable closure.
///
/// This adapter is useful when an OAuth package exposes a request function instead of a type that
/// can conform directly to ``ATRequestExecutor``.
public struct ClosureATRequestExecutor: ATRequestExecutor {

    /// The closure that executes a complete request.
    public let handler: @Sendable (URLRequest, ATRequestAuthorizationRequirement) async throws -> (Data, URLResponse)

    /// Creates a closure-backed request executor.
    ///
    /// - Parameter handler: The closure that executes a complete request.
    public init(
        handler: @escaping @Sendable (URLRequest, ATRequestAuthorizationRequirement) async throws -> (Data, URLResponse)
    ) {
        self.handler = handler
    }

    /// Executes a complete request.
    ///
    /// - Parameters:
    ///   - request: The request to execute.
    ///   - authorizationRequirement: Indicates whether the request requires session authorization.
    /// - Returns: The response body and response metadata.
    ///
    /// - Throws: An error from the underlying request closure.
    public func execute(
        _ request: URLRequest,
        authorizationRequirement: ATRequestAuthorizationRequirement
    ) async throws -> (Data, URLResponse) {
        return try await handler(request, authorizationRequirement)
    }
}
