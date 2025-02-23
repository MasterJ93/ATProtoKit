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

/// An actor which handle the most common HTTP requests for the AT Protocol.
///
/// This is, effectively, the meat of the "XRPC" portion of the AT Protocol, which creates
/// client-server and server-server communication. Only one instance of this actor can be active
/// at once.
public actor APIClientService {

    /// The `URLSession` instance to be used for network requests.
    private(set) var urlSession: URLSession
    
    /// The `UserAgent` instance to identify all network requests originating from the `ATProtoKit` sdk
    public static let userAgent: String = {
        let info = Bundle.main.infoDictionary
        let executable = (info?["CFBundleExecutable"] as? String) ??
            (ProcessInfo.processInfo.arguments.first?.split(separator: "/").last.map(String.init)) ??
            "Unknown"
        let bundle = info?["CFBundleIdentifier"] as? String ?? "Unknown"
        let appVersion = info?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let appBuild = info?["CFBundleVersion"] as? String ?? "Unknown"

        let osNameVersion: String = {
            let version = ProcessInfo.processInfo.operatingSystemVersion
            let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
            let osName: String = {
                #if os(iOS)
                #if targetEnvironment(macCatalyst)
                return "macOS(Catalyst)"
                #else
                return "iOS"
                #endif
                #elseif os(watchOS)
                return "watchOS"
                #elseif os(tvOS)
                return "tvOS"
                #elseif os(macOS)
                #if targetEnvironment(macCatalyst)
                return "macOS(Catalyst)"
                #else
                return "macOS"
                #endif
                #elseif swift(>=5.9.2) && os(visionOS)
                return "visionOS"
                #elseif os(Linux)
                return "Linux"
                #elseif os(Windows)
                return "Windows"
                #elseif os(Android)
                return "Android"
                #else
                return "Unknown"
                #endif
            }()

            return "\(osName) \(versionString)"
        }()

        /// This needs to be updated manually or read from a central location
        ///  To get truly accurate version would need to read from Package.resolved and I haven't found a way to do so
        let atProtoVersion = "ATProtoKit/0.21.0"

        let userAgent = "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) \(atProtoVersion)"

        return userAgent
    }()

    /// A `URLSession` object for use in all HTTP requests.
    public static let shared = APIClientService()

    /// Creates an instance for use in accepting and returning API requests and
    /// responses respectively.
    private init() {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["User-Agent": APIClientService.userAgent]
        self.urlSession = URLSession(configuration: sessionConfig)
    }

    /// Configures the singleton instance with a custom `URLSessionConfiguration`.
    ///
    /// - Parameter configuration: An instance of `URLSessionConfiguration`.
    public func configure(with configuration: URLSessionConfiguration) async {
        self.urlSession = URLSession(configuration: configuration)
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
    ///  - userAgent: The user agent of the client. Defaults to `.default`.
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
    public func sendRequest<T: Decodable>(_ request: URLRequest, withEncodingBody body: (Encodable & Sendable)? = nil, decodeTo: T.Type) async throws -> T {
        let data = try await self.performRequest(request, withEncodingBody: body)

        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
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
    /// - Parameters:
    ///   - request: The `URLRequest` to send.
    ///   - body: An optional `Encodable` body to be encoded and attached to the request.
    /// - Returns: A `Data` object that contains the blob.
    public func sendRequest(_ request: URLRequest, withEncodingBody body: (Encodable & Sendable)? = nil) async throws -> Data {
        let data = try await self.performRequest(request, withEncodingBody: body)
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
    private func performRequest(_ request: URLRequest, withEncodingBody body: (Encodable & Sendable)? = nil) async throws -> Data {
        // Wait for ATRecordTypeRegistry to be ready before proceeding
        for await _ in await ATRecordTypeRegistry.shared.onReady {
            break
        }

        var urlRequest = request

        if let body = body {
            do {
                urlRequest.httpBody = try body.toJsonData()
            } catch {
                throw ATHTTPRequestError.unableToEncodeRequestBody
            }
        }

        do {
            let (data, response) = try await urlSession.data(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                    case 200:
                        return data
                    case 400:
                        let errorResponse = try JSONDecoder().decode(ATHTTPResponseError.self, from: data)
                        throw ATAPIError.badRequest(error: errorResponse)
                    case 401:
                        let wwwAuthenticateHeader = httpResponse.allHeaderFields["WWW-Authenticate"] as? String
                        let errorResponse = try JSONDecoder().decode(ATHTTPResponseError.self, from: data)

                        throw ATAPIError.unauthorized(error: errorResponse, wwwAuthenticate: wwwAuthenticateHeader)
                    case 403:
                        let errorResponse = try JSONDecoder().decode(ATHTTPResponseError.self, from: data)
                        throw ATAPIError.forbidden(error: errorResponse)
                    case 404:
                        let errorResponse = try JSONDecoder().decode(ATHTTPResponseError.self, from: data)
                        throw ATAPIError.notFound(error: errorResponse)
                    case 409:
                        let errorResponse = try JSONDecoder().decode(AppBskyLexicon.Video.JobStatusDefinition.self, from: data)
                        throw ATJobStatusError.failedJob(error: errorResponse)
                    case 413:
                        let errorResponse = try JSONDecoder().decode(ATHTTPResponseError.self, from: data)
                        throw ATAPIError.payloadTooLarge(error: errorResponse)
                    case 429:
                        let retryAfterValue: TimeInterval? = if let retryAfterHeader = httpResponse.allHeaderFields["ratelimit-reset"] as? String {
                            TimeInterval(retryAfterHeader)
                        } else {
                            nil
                        }
                        let errorResponse = try JSONDecoder().decode(ATHTTPResponseError.self, from: data)

                        throw ATAPIError.tooManyRequests(error: errorResponse, retryAfter: retryAfterValue)
                    case 500:
                        let errorResponse = try JSONDecoder().decode(ATHTTPResponseError.self, from: data)
                        throw ATAPIError.internalServerError(error: errorResponse)
                    case 501:
                        let errorResponse = try JSONDecoder().decode(ATHTTPResponseError.self, from: data)
                        throw ATAPIError.methodNotImplemented(error: errorResponse)
                    case 502:
                        throw ATAPIError.badGateway
                    case 503:
                        throw ATAPIError.serviceUnavailable
                    case 504:
                        throw ATAPIError.gatewayTimeout
                    default:
                        let errorResponse = String(data: data, encoding: .utf8) ?? "No response body"
                        let errorCode = httpResponse.statusCode
                        let httpHeaders = httpResponse.allHeaderFields as? [String: String] ?? [:]

                        throw ATAPIError.unknown(error: errorResponse, errorCode: errorCode, errorData: data, httpHeaders: httpHeaders)
                }
            } else {
                throw URLError(.badServerResponse)
            }
        } catch {
            throw error
        }
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
