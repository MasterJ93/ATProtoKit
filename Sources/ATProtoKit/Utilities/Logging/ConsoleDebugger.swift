//
//  ConsoleDebugger.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-28.
//

import Foundation

/// A default implementation of the `SessionDebuggable` protocol that logs requests and responses to
/// the console.
///
/// `ConsoleDebugger` is useful for debugging network issues during development.
/// It prints detailed information about outgoing HTTP requests and incoming responses, including:
/// - Request URLs, HTTP methods, and headers
/// - Request body (if present)
/// - Response status codes, headers, and bodies
/// - Any error encountered during the request
///
/// This implementation is designed for debugging only and should not be used in production for
/// persistent logging. To use it, set the logger into ``APIClientService``.
///
/// ```swift
/// await APIClientService.shared.setLogger(ConsoleDebugger())
/// ```
public struct ConsoleDebugger: SessionDebuggable {

    /// Logs an outgoing HTTP request to the console.
    ///
    /// This method prints the request URL, HTTP method, headers, and HTTP body (if any) in a
    /// human-readable format.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` about to be sent.
    ///   - body: The encoded HTTP body data for the request. Optional.
    public func logRequest(_ request: URLRequest, body: Data?) {
        print("\n--- API REQUEST ---")
        print("URL: \(request.url?.absoluteString ?? "(nil)")")
        print("Method: \(request.httpMethod ?? "(nil)")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let body = body, let bodyStr = String(data: body, encoding: .utf8) {
            print("Body: \(bodyStr)")
        }
        print("-------------------\n")
    }

    /// Logs an incoming HTTP response to the console.
    ///
    /// This method prints the response’s status code, headers, and body (if available).
    /// If an error occurred, the error is also printed.
    ///
    /// - Parameters:
    ///   - response: The received `URLResponse` object, if any. Optional.
    ///   - data: The raw response data, if any. Optional.
    ///   - error: An `Error` if the request failed. Optional.
    public func logResponse(_ response: URLResponse?, data: Data?, error: Error?) {
        print("\n--- API RESPONSE ---")
        if let httpResponse = response as? HTTPURLResponse {
            print("Status: \(httpResponse.statusCode)")
            print("Headers: \(httpResponse.allHeaderFields)")
        }
        if let data = data, let jsonStr = String(data: data, encoding: .utf8) {
            print("Body: \(jsonStr)")
        }
        if let error = error {
            print("Error: \(error)")
        }
        print("--------------------\n")
    }
}
