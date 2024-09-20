//
//  APIClientService.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-28.
//

import Foundation
#if canImport(FoundationNetworking)
@_exported import FoundationNetworking
#endif

/// A helper class to handle the most common HTTP requests for the AT Protocol.
///
/// This is, effectively, the meat of the "XRPC" portion of the AT Protocol, which creates
/// client-server and server-server communication.
public class APIClientService {

    /// The `URLSession` instance to be used for network requests.
    private(set) var urlSession: URLSession

    /// A `URLSession` object for use in all HTTP requests.
    public static let shared = APIClientService()

    /// Creates an instance for use in accepting and returning API requests and
    /// responses respectively.
    /// 
    /// - Parameter configuration: An instance of `URLSessionConfiguration`.
    /// Defaults to `.default`.
    private init() {
        self.urlSession = URLSession(configuration: .default)
    }

    /// Configures the singleton instance with a custom `URLSessionConfiguration`.
    ///
    /// - Parameter configuration: An instance of `URLSessionConfiguration`.
    public static func configure(with configuration: URLSessionConfiguration) {
        shared.urlSession = URLSession(configuration: configuration)
    }

// MARK: Creating requests -
    /// Creates a `URLRequest` with specified parameters.
    ///
    /// - Parameters:
    ///   - requestURL: The URL for the request.
    ///   - httpMethod: The HTTP method to use (GET, POST, PUT, DELETE).
    ///   - acceptValue: The Accept header value. Defaults to "application/json".
    ///   - contentTypeValue: The Content-Type header value. Defaults to "application/json".
    ///   - authorizationValue: The Authorization header value. Optional.
    ///   - proxyValue: The `atproto-proxy` header value. Optional.
    ///   - labelersValue: The `atproto-accept-labelers` value. Optional.
    ///   - isRelatedToBskyChat: Indicates whether to use the "atproto-proxy" header for
    ///   the value specific to Bluesky DMs. Optional. Defaults to `false`.
    /// - Returns: A configured `URLRequest` instance.
    public static func createRequest(forRequest requestURL: URL, andMethod httpMethod: HTTPMethod, acceptValue: String? = "application/json",
                                     contentTypeValue: String? = "application/json", authorizationValue: String? = nil,
                                     labelersValue: String? = nil, proxyValue: String? = nil, isRelatedToBskyChat: Bool = false) -> URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = httpMethod.rawValue

        if let acceptValue {
            request.addValue(acceptValue, forHTTPHeaderField: "Accept")
        }
        if let authorizationValue {
            request.addValue(authorizationValue, forHTTPHeaderField: "Authorization")
        }

        // Send the data if it matches a POST or PUT request.
        if httpMethod == .post || httpMethod == .put {
            if let contentTypeValue {
                request.addValue(contentTypeValue, forHTTPHeaderField: "Content-Type")
            }
        }

        // Send the data specifically for proxy-related data.
        if let proxyValue {
            request.addValue(proxyValue, forHTTPHeaderField: "atproto-proxy")
        }
        // Send the data specifically for label-related calls.
        if let labelersValue {
            request.addValue(labelersValue, forHTTPHeaderField: "atproto-accept-labelers")
        }

        if isRelatedToBskyChat {
            request.addValue("did:web:api.bsky.chat#bsky_chat", forHTTPHeaderField: "atproto-proxy")
        }

        return request
    }

    func encode<T: Encodable>(_ jsonData: T) async throws -> Data {
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonData) else {
            throw ATHTTPRequestError.unableToEncodeRequestBody
        }
        return httpBody
    }


    /// Sets query items for a given URL.
    ///
    /// - Parameters:
    ///   - requestURL: The base URL to append query items to.
    ///   - queryItems: An array of key-value pairs to be set as query items.
    /// - Returns: A new URL with the query items appended.
    public static func setQueryItems(for requestURL: URL, with queryItems: [(String, String)]) throws -> URL {
        var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: true)

        // Map out each URLQueryItem with the key ($0.0) and value ($0.1) of the item.
        components?.queryItems = queryItems.map { URLQueryItem(name: $0.0, value: $0.1) }

        guard let finalURL = components?.url else {
            throw ATHTTPRequestError.failedToConstructURLWithParameters
        }
        return finalURL
    }

// MARK: Sending requests -
    /// Sends a `URLRequest` and decodes the response to a specified `Decodable` type.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` to send.
    ///   - body: An optional `Encodable` body to be encoded and attached to the request.
    ///   - decodeTo: The type to decode the response into.
    /// - Returns: An instance of the specified `Decodable` type.
    public func sendRequest<T: Decodable>(_ request: URLRequest, withEncodingBody body: Encodable? = nil, decodeTo: T.Type) async throws -> T {
        let (data, _) = try await self.performRequest(request, withEncodingBody: body)

        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }

    /// Sends a `URLRequest` without expecting a specific decoded response type.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` to send.
    ///   - body: An optional `Encodable` body to be encoded and attached to the request.
    public func sendRequest(_ request: URLRequest, withEncodingBody body: Encodable? = nil) async throws {
        _ = try await self.performRequest(request, withEncodingBody: body)
    }

    /// Sends a `URLRequest` in order to receive a data object.
    ///
    /// Typically, this will be used for getting a blob object as the output. However, this is
    /// also useful for when the output is an unknown format, can be any format,
    /// or is unreliable. If it can be any format or if the format is unreliable, it's your
    /// responsibility to handle the information stored inside the `Data` object. If the output is
    /// known and it's not a blob, however, then the other `sendRequest` methods are
    /// more appropriate.
    ///
    /// - Parameter request: The `URLRequest` to send.
    /// - Returns: A `Data` object that contains the blob.
    public func sendRequest(_ request: URLRequest) async throws -> Data {
        let (data, _) = try await self.performRequest(request)
        return data
    }

    /// Sends a raw file to a server.
    ///
    /// - Parameters:
    ///   - request: The URL to send the request to.
    ///   - data: The file object itself.
    ///   - decodeTo: The type to decode the response into.
    /// - Returns: An instance of the specified `Decodable` type.
    public func sendRequest<T: Decodable>(_ request: URLRequest, withDataBody data: Data, decodeTo: T.Type) async throws -> T {
        let urlRequest = request

        // let (data, response) = try await
        let (responseData, response) = try await urlSession.upload(for: urlRequest, from: data)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ATHTTPRequestError.errorGettingResponse
        }

        guard httpResponse.statusCode == 200 else {
            let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
            print("HTTP Status Code: \(httpResponse.statusCode) - Response Body: \(responseBody)")
            throw URLError(.badServerResponse)
        }

        let decodedData = try JSONDecoder().decode(T.self, from: responseData)
        return decodedData
    }

    /// Sends a `URLRequest` and returns the raw JSON output as a `Dictionary`.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` to send.
    ///   - body: An optional `Encodable` body to be encoded and attached to the request.
    /// - Returns: A `Dictionary` representation of the JSON response.
    public func sendRequestWithRawJSONOutput(_ request: URLRequest, withEncodingBody body: Encodable? = nil) async throws -> [String: Any] {
        var urlRequest = request

        // Encode the body to JSON data if it's not nil
        if let body = body {
            do {
                urlRequest.httpBody = try body.toJsonData()
            } catch {
                throw ATHTTPRequestError.unableToEncodeRequestBody
            }
        }

        let (data, response) = try await urlSession.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ATHTTPRequestError.errorGettingResponse
        }

        guard httpResponse.statusCode == 200 else {
            let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
            print("HTTP Status Code: \(httpResponse.statusCode) - Response Body: \(responseBody)")
            throw URLError(.badServerResponse)
        }

        guard let response = try JSONSerialization.jsonObject(
            with: data, options: .mutableLeaves) as? [String: Any] else { return ["Response": "No response"] }
        return response
    }

    /// Sends a `URLRequest` and returns the raw HTML output as a `String`.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` to send.
    /// - Returns: A `String` representation of the HTML response.
    public static func sendRequestWithRawHTMLOutput(_ request: URLRequest) async throws -> String {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ATHTTPRequestError.errorGettingResponse
        }

        guard httpResponse.statusCode == 200 else {
            let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
            print("HTTP Status Code: \(httpResponse.statusCode) - Response Body: \(responseBody)")
            throw URLError(.badServerResponse)
        }

        guard let htmlString = String(data: data, encoding: .utf8) else {
            throw ATHTTPRequestError.failedToDecodeHTML
        }

        return htmlString
    }

    /// Private method to handle the common request sending logic.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` to send.
    ///   - body: An optional `Encodable` body to be encoded and attached to the request.
    /// - Returns: A tuple containing the data and the HTTPURLResponse.
    private func performRequest(_ request: URLRequest, withEncodingBody body: Encodable? = nil) async throws -> (Data, HTTPURLResponse) {
        var urlRequest = request

        if let body = body {
            do {
                urlRequest.httpBody = try body.toJsonData()
            } catch {
                throw ATHTTPRequestError.unableToEncodeRequestBody
            }
        }

        let (data, response) = try await urlSession.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ATHTTPRequestError.errorGettingResponse
        }

//        print("Status Code: \(httpResponse.statusCode)")  // Debugging line
//        print("Response Headers: \(httpResponse.allHeaderFields)")  // Debugging line

        guard httpResponse.statusCode == 200 else {
            let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
            print("HTTP Status Code: \(httpResponse.statusCode) - Response Body: \(responseBody)")
            throw URLError(.badServerResponse)
        }

        return (data, httpResponse)
    }

// MARK: -
    /// Represents the HTTP methods used to interact with the AT Protocol.
    public enum HTTPMethod: String {
        /// Retrieve information from the AT Protocol using a given URI.
        case get = "GET"
        /// Sends data to the AT Protocol to create or update a resource.
        case post = "POST"
        /// Replaces all current representations of the target resource with the request payload.
        case put = "PUT"
        /// Removes the specified resource(s) from the AT Protocol server.
        case delete = "DELETE"
    }

//    ///
//    public enum ATProtoProxy: String {
//
//        case bskyChat = "did:web:api.bsky.chat#bsky_chat"
//        case test = ""
//    }

    /// Determines the MIME type based on a file's extension.
    ///
    /// - Parameter filename: The filename to determine the MIME type for.
    /// - Returns: A string representing the MIME type.
    package static func mimeType(for filename: String) -> String {
        let suffix = filename.split(separator: ".").last?.lowercased() ?? ""
        switch suffix {
            case "png": return "image/png"
            case "jpeg", "jpg": return "image/jpeg"
            case "webp": return "image/webp"
            case "mp4": return "video/mp4"
            case "mov": return "video/quicktime"
            default: return "application/octet-stream"
        }
    }
}
