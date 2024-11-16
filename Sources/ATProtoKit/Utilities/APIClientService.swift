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
                                     labelersValue: String? = nil, proxyValue: String? = nil, isRelatedToBskyChat: Bool = false,
                                     userAgent: UserAgent = .default) -> URLRequest {
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
        let data = try await self.performRequest(request, withEncodingBody: body)

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
        let data = try await self.performRequest(request)
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
    private func performRequest(_ request: URLRequest, withEncodingBody body: Encodable? = nil) async throws -> Data {
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
                        let retryAfterHeader = httpResponse.allHeaderFields["Retry-After"] as? TimeInterval
                        let errorResponse = try JSONDecoder().decode(ATHTTPResponseError.self, from: data)

                        throw ATAPIError.tooManyRequests(error: errorResponse, retryAfter: retryAfterHeader)
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

    /// An enum that determines the User Agent for the client.
    public enum UserAgent {

        /// A default User Agent will be provided.
        ///
        /// - Note: Example: `ATProtoKit/0.20.0 (iOS; 18.1)`
        case `default`

        /// A custom User Agent will be provided.
        ///
        /// When creating a user agent, it's good to create a specific structure. Here's a
        /// recommended approach.
        ///
        /// ```
        /// Skyline 2.1 (iOS; 18.1) ATProtoKit/0.20.0
        /// ```
        ///
        /// - `Skyline`: Name of the client.
        /// - `2.1`: This is the version number of your client.
        /// - `iOS`: The operating system the client is running on.
        /// - `18.1`: The version number of the operating system.
        /// - `ATProtoKit`: This ATProtocol client.
        /// - `0.20.0`: The version ATProtoKit is the client is currently running on.
        ///
        /// - Note: The "ATProtoKit" name and its version number will always be displayed,
        /// so there's no need to add it yourself.
        case custom(userAgent: String)

        /// No User Agent will be provided.
        ///
        /// - Warning: It's recommended that you _don't_ use this for production use. Only use
        /// this if you need to test things.
        case none

        var value: String {
            switch self {
                case .default:
                    return "ATProtoKit/\(versionNumber) (\(osNameAndVersion)"
                case .custom(let customUserAgent):
                    return "\(customUserAgent) ATProtoKit/\(versionNumber)"
                case .none:
                    return ""
            }
        }

        private var osNameAndVersion: String {
            #if os(macOS)
            return "macOS; \(grabAppleOSVersion)"
            #elseif os(iOS)
            return "iOS; \(grabAppleOSVersion)"
            #elseif os(tvOS)
            return "tvOS; \(grabAppleOSVersion)"
            #elseif os(watchOS)
            return "watchOS; \(grabAppleOSVersion)"
            #elseif os(visionOS)
            return "visionOS; \(grabAppleOSVersion)"
            #elseif os(Linux)
            return "\(grabLinuxVersion)"
            #elseif os(Windows)
            return "\(grabLinuxVersion)"
            #else
            return "UnknownOS"
            #endif
        }

        /// Grabs the Apple OS's name and version number.
        ///
        /// - Note: Only works on iOS, iPadOS, tvOS, watchOS, or visionOS.
        public var grabAppleOSVersion: String {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
            let majorVersion = ProcessInfo.processInfo.operatingSystemVersion.majorVersion
            let minorVersion = ProcessInfo.processInfo.operatingSystemVersion.minorVersion
            let patchVersion = ProcessInfo.processInfo.operatingSystemVersion.minorVersion

            return "\(majorVersion).\(minorVersion).\(patchVersion)"
            #endif
        }

        /// Grabs the Linux distro's name and version number.
        ///
        /// - Note: Only works on Linux.
        private var grabLinuxVersion: String {
            guard let osReleaseContents = try? String(contentsOfFile: "/etc/os-release") else {
                return "Linux"
            }

            var linuxName: String = "Linux"
            var versionNumber: String?

            let lines = osReleaseContents.split(separator: "\n")

            for line in lines {
                let parts = line.split(separator: "=", maxSplits: 1).map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }

                guard parts.count == 2 else { continue }

                // Check if the "key" is equal to "NAME". If so, set `linuxName`.
                if parts[0] == "NAME" {
                    linuxName = parts[1].replacingOccurrences(of: "\"", with: "")
                }

                // Check if the "key" is equal to "VERSION_ID". If so, set `versionNumber`.
                if parts[0] == "VERSION_ID" {
                    versionNumber = parts[1].replacingOccurrences(of: "\"", with: "")
                }
            }

            // Return the formatted OS name with version if available
            return versionNumber != nil ? "\(linuxName) \(versionNumber!)" : linuxName
        }

        /// Grabs the Windows number and build.
        ///
        /// - Note: Only works on Windows.
        /// - Bug: At this time, it's only able to figure out whether Windows is being used
        /// or not. There's currently no easy way to determine if it's Windows 10, 11, or some
        /// other version.
        private var grabWindowsVersion: String {
            #if os(Windows)
            return "Windows"
            #endif
            return "UnknownOS"
        }
    }
}
