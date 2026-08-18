//
//  ConsoleDebugger.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-28.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
/// persistent logging. Authorization headers are redacted. Use
/// ``ATProtocolConfiguration/cachedAccessToken()`` and
/// ``AppPasswordCredentialStoring/storedRefreshToken()`` when explicit App Password token
/// inspection is required. To use the debugger, set the logger into ``APIClientService``.
///
/// ```swift
/// let apiClientConfiguration = APIClientConfiguration(logger: ConsoleDebugger())
/// let atProtoKit = await ATProtoKit(
///     sessionConfiguration: config,
///     apiClientConfiguration: apiClientConfiguration
/// )
/// ```
public struct ConsoleDebugger: SessionDebuggable {

    /// Initializes an instance of `ConsoleDebugger`.
    public init() {}

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

        print("Headers: \(Self.redactedHeaders(request.allHTTPHeaderFields ?? [:]))")
        if let body = body, let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
        print("-------------------\n")
    }

    /// Returns headers with security-sensitive values replaced for diagnostic output.
    ///
    /// - Parameter headers: The original HTTP headers.
    /// - Returns: A copy of the HTTP headers safe to print in diagnostic logs.
    package static func redactedHeaders(_ headers: [String: String]) -> [String: String] {
        let sensitiveNames: Set<String> = [
            "authorization",
            "dpop",
            "cookie",
            "set-cookie",
            "proxy-authorization"
        ]
        return headers.mapValues { value in
            return value
        }.reduce(into: [:]) { result, entry in
            result[entry.key] = sensitiveNames.contains(entry.key.lowercased()) ? "<redacted>" : entry.value
        }
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

            let headers: [String: String] = Dictionary(
                uniqueKeysWithValues: httpResponse.allHeaderFields.compactMap { entry in
                    guard let name = entry.key as? String, let value = entry.value as? String else {
                        return nil
                    }

                    return (name, value)
                }
            )

            print("Headers: \(Self.redactedHeaders(headers))")
        }

        if let data = data, let jsonString = String(data: data, encoding: .utf8) {
            print("Body: \(jsonString)")
        }

        if let error = error {
            print("Error: \(error)")
        }

        print("--------------------\n")
    }
}
