//
//  APIClientService.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-28.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A struct which handle the most common HTTP requests for the AT Protocol.
///
/// This is, effectively, the meat of the "XRPC" portion of the AT Protocol, which creates
/// the communitcation between the client and the server.
public struct APIClientService: Sendable {

    /// The `URLSession` instance to be used for network requests.
    public private(set) var urlSession: URLSession = URLSession(configuration: .default)

    /// An instance of ``ATRequestExecutor``.
    private var executor: ATRequestExecutor?

    /// A logger for logging HTTP requests and responses.
    private var logger: SessionDebuggable? = nil

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

    /// Initializes an API client service using the specified configuration.
    ///
    /// Use this initializer to create an API client that accepts and returns API requests and responses,
    /// with support for custom session configuration, delegate handling, response providers, and logging.
    ///
    /// - Parameters:
    ///   - configuration: The ``APIClientConfiguration`` instance containing all customization options.
    ///     This includes the session configuration, delegate, delegate queue, response provider, and logger.
    ///     If `urlSessionConfiguration` is `nil`, `.default` is used. If `responseProvider` or `logger` are
    ///     `nil`, the defaults are used.
    ///
    /// - SeeAlso:
    ///   - ``APIClientConfiguration``
    public init(with configuration: APIClientConfiguration) {
        let config = configuration.urlSessionConfiguration ?? .default
        config.httpAdditionalHeaders = ["User-Agent": APIClientService.userAgent]
        self.urlSession = URLSession(configuration: config, delegate: configuration.delegate, delegateQueue: configuration.delegateQueue)
        self.executor = configuration.responseProvider
        self.logger = configuration.logger
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
    public func createRequest(forRequest requestURL: URL, andMethod httpMethod: HTTPMethod, acceptValue: String? = "application/json",
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
    public func setQueryItems(for requestURL: URL, with queryItems: [(String, String)]) throws -> URL {
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

    /// Private method to handle the common request sending logic.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` to send.
    ///   - body: An optional `Encodable` body to be encoded and attached to the request.
    /// - Returns: A tuple containing the data and the HTTPURLResponse.
    private func performRequest(_ request: URLRequest, withEncodingBody body: (Encodable & Sendable)? = nil) async throws -> Data {
        // Wait for ATRecordTypeRegistry to be ready before proceeding
        await ATRecordTypeRegistry.shared.waitUntilRegistryIsRead()

        var urlRequest = request
        var httpBodyData: Data? = nil

        if let body = body {
            do {
                httpBodyData = try body.toJsonData()
                urlRequest.httpBody = httpBodyData
            } catch {
                throw ATHTTPRequestError.unableToEncodeRequestBody
            }
        }

        #if DEBUG
        self.logger?.logRequest(urlRequest, body: httpBodyData)
        #endif

        do {
            let (data, response): (Data, URLResponse)
            if let executor = self.executor {
                (data, response) = try await executor.execute(urlRequest)
            } else {
                (data, response) = try await urlSession.data(for: urlRequest)
            }

            #if DEBUG
            self.logger?.logResponse(response, data: data, error: nil)
            #endif
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                    case 200:
                        return data
                    case 400:
                        let errorResponse = try JSONDecoder().decode(ATHTTPResponseError.self, from: data)

                        #if DEBUG
                        self.logger?.logResponse(nil, data: nil, error: errorResponse)
                        #endif
                        throw ATAPIError.badRequest(error: errorResponse)
                    case 401:
                        let wwwAuthenticateHeader = httpResponse.allHeaderFields["WWW-Authenticate"] as? String
                        let errorResponse = try JSONDecoder().decode(ATHTTPResponseError.self, from: data)

                        #if DEBUG
                        self.logger?.logResponse(nil, data: nil, error: errorResponse)
                        #endif
                        throw ATAPIError.unauthorized(error: errorResponse, wwwAuthenticate: wwwAuthenticateHeader)
                    case 403:
                        let errorResponse = try JSONDecoder().decode(ATHTTPResponseError.self, from: data)

                        #if DEBUG
                        self.logger?.logResponse(nil, data: nil, error: errorResponse)
                        #endif
                        throw ATAPIError.forbidden(error: errorResponse)
                    case 404:
                        let errorResponse = try JSONDecoder().decode(ATHTTPResponseError.self, from: data)

                        #if DEBUG
                        self.logger?.logResponse(nil, data: nil, error: errorResponse)
                        #endif
                        throw ATAPIError.notFound(error: errorResponse)
                    case 409:
                        let errorResponse = try JSONDecoder().decode(AppBskyLexicon.Video.JobStatusDefinition.self, from: data)

                        #if DEBUG
                        self.logger?.logResponse(nil, data: nil, error: errorResponse)
                        #endif
                        throw ATJobStatusError.failedJob(error: errorResponse)
                    case 413:
                        let errorResponse = try JSONDecoder().decode(ATHTTPResponseError.self, from: data)

                        #if DEBUG
                        self.logger?.logResponse(nil, data: nil, error: errorResponse)
                        #endif
                        throw ATAPIError.payloadTooLarge(error: errorResponse)
                    case 429:
                        let retryAfterValue: TimeInterval? = if let retryAfterHeader = httpResponse.allHeaderFields["ratelimit-reset"] as? String {
                            TimeInterval(retryAfterHeader)
                        } else {
                            nil
                        }
                        let errorResponse = try JSONDecoder().decode(ATHTTPResponseError.self, from: data)

                        #if DEBUG
                        self.logger?.logResponse(nil, data: nil, error: errorResponse)
                        #endif
                        throw ATAPIError.tooManyRequests(error: errorResponse, retryAfter: retryAfterValue)
                    case 500:
                        let errorResponse = try JSONDecoder().decode(ATHTTPResponseError.self, from: data)

                        #if DEBUG
                        self.logger?.logResponse(nil, data: nil, error: errorResponse)
                        #endif
                        throw ATAPIError.internalServerError(error: errorResponse)
                    case 501:
                        let errorResponse = try JSONDecoder().decode(ATHTTPResponseError.self, from: data)

                        #if DEBUG
                        self.logger?.logResponse(nil, data: nil, error: errorResponse)
                        #endif
                        throw ATAPIError.methodNotImplemented(error: errorResponse)
                    case 502:
                        let error = ATAPIError.badGateway

                        #if DEBUG
                        self.logger?.logResponse(nil, data: nil, error: error)
                        #endif
                        throw error
                    case 503:
                        let error = ATAPIError.serviceUnavailable

                        #if DEBUG
                        self.logger?.logResponse(nil, data: nil, error: error)
                        #endif
                        throw error
                    case 504:
                        let error = ATAPIError.gatewayTimeout

                        #if DEBUG
                        self.logger?.logResponse(nil, data: nil, error: error)
                        #endif
                        throw error
                    default:
                        let errorResponse = String(data: data, encoding: .utf8) ?? "No response body"
                        let errorCode = httpResponse.statusCode
                        let httpHeaders = httpResponse.allHeaderFields as? [String: String] ?? [:]
                        let error = ATAPIError.unknown(error: errorResponse, errorCode: errorCode, errorData: data, httpHeaders: httpHeaders)

                        #if DEBUG
                        self.logger?.logResponse(nil, data: nil, error: error)
                        #endif
                        throw error
                }
            } else {
                #if DEBUG
                self.logger?.logResponse(nil, data: nil, error: URLError(.badServerResponse))
                #endif
                throw URLError(.badServerResponse)
            }
        } catch {
            #if DEBUG
            self.logger?.logResponse(nil, data: nil, error: error)
            #endif
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
