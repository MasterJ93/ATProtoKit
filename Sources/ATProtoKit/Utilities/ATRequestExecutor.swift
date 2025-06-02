//
//  ATRequestExecutor.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-04-18.
//

import Foundation

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
    /// - Parameter request: The `URLRequest` to execute.
    /// - Returns: A tuple, containing the response body as `Data`, and the `URLResponse` metadata.
    ///
    /// - Throws: An error if the request fails, is cancelled, or if a networking error occurs.
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse)
}
