//
//  SessionDebuggable.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-28.
//

import Foundation

/// A protocol for debugging and inspecting HTTP requests and responses within a network session.
///
/// Conform to `SessionDebuggable` to receive callbacks whenever a network request is sent or a response
/// is received. This enables custom logging, analytics, or inspection of JSON payloads, headers, URLs, and
/// error states.
///
/// Implement this protocol to log data to the console, a file, an in-app debug UI, or send logs remotely.
/// For convenience, ATProtoKit provides a default implementation called ``ConsoleDebugger``.
///
/// To use a `SessionDebuggable`-conforming `struct` or `class`, create an instance of
/// ``APIClientConfiguration`` and attach the `struct` or `class` in it. Then insert it into the instance
/// of `ATProtoKit`.
///
/// ```swift
/// let apiClientConfiguration = APIClientConfiguration(logger: ConsoleDebugger())
/// let atProtoKit = ATProtoKit(
///     sessionConfiguration: config,
///     apiClientConfiguration: apiClientConfiguration
/// )
/// ```
///
/// - Note: Learn more about this protocol by reading "<doc:SessionDebuggableArticle>."
public protocol SessionDebuggable: Sendable {

    /// Creates a log immediately before an HTTP request is sent.
    ///
    /// Use this method to inspect or log the outgoing request’s URL, headers, HTTP method, and body.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` about to be sent.
    ///   - body: The encoded HTTP body data for the request. Optional.
    func logRequest(_ request: URLRequest, body: Data?)

    /// Creates a log immediately after a response is received (or a request fails).
    ///
    /// Use this method to inspect or log the response’s status code, headers, body, and any error
    /// that may have occurred during the request.
    ///
    /// - Parameters:
    ///   - response: The received `URLResponse` object, if any. Optional.
    ///   - data: The raw response data, if any. Optional.
    ///   - error: An `Error` if the request failed. Optional.
    func logResponse(_ response: URLResponse?, data: Data?, error: Error?)
}
