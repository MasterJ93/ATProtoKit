//
//  APIClientService.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-28.
//

import Foundation
import Logging

/// A helper class to handle the most common HTTP Requests for the AT Protocol.
public class APIClientService {
    private static var logger = Logger(label: "APIClientService")
    
    private init() {}

// MARK: Creating requests -
    /// Creates a `URLRequest` with specified parameters.
    /// - Parameters:
    ///   - requestURL: The URL for the request.
    ///   - httpMethod: The HTTP method to use (GET, POST, PUT, DELETE).
    ///   - acceptValue: The Accept header value. Defaults to "application/json".
    ///   - contentTypeValue: The Content-Type header value. Defaults to "application/json".
    ///   - authorizationValue: The Authorization header value. Optional.
    ///   - proxyValue: The `atproto-proxy` header value. Optional.
    ///   - labelersValue: The `atproto-accept-labelers` value. Optional.
    /// - Returns: A configured `URLRequest` instance.
    public static func createRequest(forRequest requestURL: URL, andMethod httpMethod: HTTPMethod, acceptValue: String? = "application/json",
                                     contentTypeValue: String? = "application/json", authorizationValue: String? = nil,
                                     labelersValue: String? = nil, proxyValue: String? = nil) -> URLRequest {
        logger.trace("In createRequest()")
        var request = URLRequest(url: requestURL)
        request.httpMethod = httpMethod.rawValue

        if let acceptValue {
            logger.trace("Adding header", metadata: ["Accept": "\(acceptValue)"])
            request.addValue(acceptValue, forHTTPHeaderField: "Accept")
        }
        if let authorizationValue {
            logger.trace("Adding header", metadata: ["Authorization": "\(authorizationValue)"])
            request.addValue(authorizationValue, forHTTPHeaderField: "Authorization")
        }

        // Send the data if it matches a POST or PUT request.
        if httpMethod == .post || httpMethod == .put {
            if let contentTypeValue {
                logger.trace("Adding header", metadata: ["Content-Type": "\(contentTypeValue)"])
                request.addValue(contentTypeValue, forHTTPHeaderField: "Content-Type")
            }
        }

        // Send the data specifically for proxy-related data.
        if let proxyValue {
            logger.trace("Adding header", metadata: ["atproto-proxy": "\(proxyValue)"])
            request.addValue(proxyValue, forHTTPHeaderField: "atproto-proxy")
        }
        // Send the data specifically for label-related calls.
        if let labelersValue {
            logger.trace("Adding header", metadata: ["atproto-accept-labelers": "\(labelersValue)"])
            request.addValue(labelersValue, forHTTPHeaderField: "atproto-accept-labelers")
        }

        logger.debug("Created request successfully")
        logger.trace("Exiting createRequest()")
        return request
    }

    static func encode<T: Encodable>(_ jsonData: T) async throws -> Data {
        logger.trace("In encode()")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonData) else {
            logger.error("Data encoding failed with error", metadata: ["error": "\(ATHTTPRequestError.unableToEncodeRequestBody)"])
            throw ATHTTPRequestError.unableToEncodeRequestBody
        }
        logger.debug("Body contents have been encoded successfully", metadata: ["size": "\(httpBody.count)"])
        logger.trace("Exiting encode()")
        return httpBody
    }


    /// Sets query items for a given URL.
    /// - Parameters:
    ///   - requestURL: The base URL to append query items to.
    ///   - queryItems: An array of key-value pairs to be set as query items.
    /// - Returns: A new URL with the query items appended.
    public static func setQueryItems(for requestURL: URL, with queryItems: [(String, String)]) throws -> URL {
        logger.trace("In setQueryItems()")
        var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: true)

        logger.debug("Setting query items", metadata: ["size": "\(queryItems.count)"])
        // Map out each URLQueryItem with the key ($0.0) and value ($0.1) of the item.
        components?.queryItems = queryItems.map { URLQueryItem(name: $0.0, value: $0.1) }

        guard let finalURL = components?.url else {
            logger.error("Error while setting query items", metadata: ["error": "\(ATHTTPRequestError.failedToConstructURLWithParameters)"])
            throw ATHTTPRequestError.failedToConstructURLWithParameters
        }
        
        logger.debug("Query items have been set successfully")
        logger.trace("Exiting setQueryItems()")
        return finalURL
    }

// MARK: Sending requests -
    /// Sends a `URLRequest` and decodes the response to a specified `Decodable` type.
    /// - Parameters:
    ///   - request: The `URLRequest` to send.
    ///   - body: An optional `Encodable` body to be encoded and attached to the request.
    ///   - decodeTo: The type to decode the response into.
    /// - Returns: An instance of the specified `Decodable` type.
    public static func sendRequest<T: Decodable>(_ request: URLRequest, withEncodingBody body: Encodable? = nil, decodeTo: T.Type) async throws -> T {
        logger.trace("In sendRequest()")
        
        logger.debug("Sending request", metadata: ["url": "\(String(describing: request.url))", "method": "\(String(describing: request.httpMethod))"])
        let (data, _) = try await performRequest(request, withEncodingBody: body)
        logger.debug("Request has been sent successfully")
        
        logger.debug("Decoding the response data", metadata: ["size": "\(data.count)"])
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        logger.debug("Data decoded successfully")
        
        logger.trace("Exiting sendRequest()")
        return decodedData
    }

    /// Sends a `URLRequest` without expecting a specific decoded response type.
    /// - Parameters:
    ///   - request: The `URLRequest` to send.
    ///   - body: An optional `Encodable` body to be encoded and attached to the request.
    public static func sendRequest(_ request: URLRequest, withEncodingBody body: Encodable? = nil) async throws {
        logger.trace("In sendRequest()")
        _ = try await performRequest(request, withEncodingBody: body)
        logger.trace("Exiting sendRequest()")
    }

    /// Sends a `URLRequest` in order to receive a data object.
    ///
    /// Typically, this will be used for getting a blob object as the output. However, this is
    /// also useful for when the output is an unknown format, can be any format,
    /// or is unreliable. If it can be any format or if the format is unreliable, it's your
    /// responsibility to handle the information stored inside the `Data` object. If the output is
    /// known and it's not a blob, however, then the other `sendRequest` methods are
    /// more appropriate.
    /// - Parameter request: The `URLRequest` to send.
    /// - Returns: A `Data` object that contains the blob.
    public static func sendRequest(_ request: URLRequest) async throws -> Data {
        logger.trace("In sendRequest()")
        let (data, _) = try await performRequest(request)
        logger.debug("Data received from request", metadata: ["size": "\(data.count)"])
        logger.trace("Exiting sendRequest()")
        return data
    }

    /// Uploads a blob to a specified URL with multipart/form-data encoding.
    ///
    /// - Note: According to the AT Protocol specifications: "Upload a new blob, to be referenced
    /// from a repository record. The blob will be deleted if it is not referenced within a time
    /// window (eg, minutes). Blob restrictions (mimetype, size, etc) are enforced when the
    /// reference is created. Requires auth, implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.uploadBlob`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/uploadBlob.json
    ///
    /// - Parameters:
    ///   - pdsURL: The base URL for the blob upload.
    ///   - accessToken: The access token for authorization.
    ///   - filename: The filename of the blob to upload.
    ///   - imageData: The data of the blob to upload.
    /// - Returns: A `BlobContainer` instance with the upload result.
    public static func uploadBlob(pdsURL: String = "https://bsky.social", accessToken: String, filename: String,
                                  imageData: Data) async throws -> ComAtprotoLexicon.Repository.BlobContainer {
         logger.trace("In uploadBlob()")
         guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.repo.uploadBlob") else {
             logger.error("Error while uploading blob", metadata: ["error": "\(ATRequestPrepareError.invalidRequestURL)"])
             throw ATRequestPrepareError.invalidRequestURL
         }

        let mimeType = mimeType(for: filename)

        do {
            var request = createRequest(
                forRequest: requestURL,
                andMethod: .post,
                contentTypeValue: mimeType,
                authorizationValue: "Bearer \(accessToken)")
            request.httpBody = imageData

            logger.debug("Uploading blob", metadata: ["url": "\(requestURL)", "mime-type": "\(mimeType)", "size": "\(imageData.count)"])
            let response = try await sendRequest(request,
                                                 decodeTo: ComAtprotoLexicon.Repository.BlobContainer.self)

            logger.debug("Blob upload successful")
            logger.trace("Exiting uploadBlob()")
            return response
        } catch {
            logger.error("Error while uploading blob", metadata: ["error": "\(error)"])
            throw ATHTTPRequestError.invalidResponse
        }
    }

    /// Sends a `URLRequest` and returns the raw JSON output as a `Dictionary`.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` to send.
    ///   - body: An optional `Encodable` body to be encoded and attached to the request.
    /// - Returns: A `Dictionary` representation of the JSON response.
    public static func sendRequestWithRawJSONOutput(_ request: URLRequest, withEncodingBody body: Encodable? = nil) async throws -> [String: Any] {
        logger.trace("In sendRequestWithRawJSONOutput()")
        var urlRequest = request

        // Encode the body to JSON data if it's not nil
        logger.debug("Building the request to send", metadata: ["url": "\(String(describing: request.url))", "method": "\(String(describing: request.httpMethod))"])
        if let body = body {
            do {
                logger.debug("Encoding request body to JSON")
                urlRequest.httpBody = try body.toJsonData()
                logger.debug("Encoded request body has been set", metadata: ["size": "\(String(describing: urlRequest.httpBody?.count))"])
            } catch {
                logger.error("Error while setting the encoded request body", metadata: ["error": "\(error)"])
                throw ATHTTPRequestError.unableToEncodeRequestBody
            }
        }

        logger.debug("Sending the request")
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("Error while sending the request", metadata: ["error": "\(ATHTTPRequestError.errorGettingResponse)"])
            throw ATHTTPRequestError.errorGettingResponse
        }

        guard httpResponse.statusCode == 200 else {
            let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
            logger.error("Error while sending the request", metadata: ["status": "\(httpResponse.statusCode)", "responseBody": "\(responseBody)"])
            throw URLError(.badServerResponse)
        }

        guard let response = try JSONSerialization.jsonObject(
            with: data, options: .mutableLeaves) as? [String: Any] else { return ["Response": "No response"] }
        
        logger.debug("Request sent successfully")
        logger.trace("Exiting sendRequestWithRawJSONOutput()")
        return response
    }

    /// Sends a `URLRequest` and returns the raw HTML output as a `String`.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` to send.
    /// - Returns: A `String` representation of the HTML response.
    public static func sendRequestWithRawHTMLOutput(_ request: URLRequest) async throws -> String {
        logger.trace("In sendRequestWithRawHTMLOutput()")
        
        logger.debug("Sending request", metadata: ["url": "\(String(describing: request.url))", "method": "\(String(describing: request.httpMethod))"])
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("Error while sending request", metadata: ["error": "\(ATHTTPRequestError.errorGettingResponse)"])
            throw ATHTTPRequestError.errorGettingResponse
        }

        guard httpResponse.statusCode == 200 else {
            let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
            print("HTTP Status Code: \(httpResponse.statusCode) - Response Body: \(responseBody)")
            logger.error("Error while sending the request", metadata: ["status": "\(httpResponse.statusCode)", "responseBody": "\(responseBody)"])
            throw URLError(.badServerResponse)
        }

        guard let htmlString = String(data: data, encoding: .utf8) else {
            logger.error("Error while decoding the response", metadata: ["error": "\(ATHTTPRequestError.failedToDecodeHTML)"])
            throw ATHTTPRequestError.failedToDecodeHTML
        }

        logger.debug("Request sent successfully")
        logger.trace("Exiting sendRequestWithRawHTMLOutput()")
        return htmlString
    }

    /// Private method to handle the common request sending logic.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` to send.
    ///   - body: An optional `Encodable` body to be encoded and attached to the request.
    /// - Returns: A tuple containing the data and the HTTPURLResponse.
    private static func performRequest(_ request: URLRequest, withEncodingBody body: Encodable? = nil) async throws -> (Data, HTTPURLResponse) {
        logger.trace("In performRequest()")
        var urlRequest = request

        logger.debug("Building the request", metadata: ["url": "\(String(describing: request.url))", "method": "\(String(describing: request.httpMethod))"])
        if let body = body {
            do {
                urlRequest.httpBody = try body.toJsonData()
                logger.debug("Request body has been set", metadata: ["size": "\(String(describing: urlRequest.httpBody?.count))"])
            } catch {
                logger.error("Error while setting the request body", metadata: ["error": "\(error)"])
                throw ATHTTPRequestError.unableToEncodeRequestBody
            }
        }

        logger.debug("Sending the request")
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("Error while sending the request", metadata: ["error": "\(ATHTTPRequestError.errorGettingResponse)"])
            throw ATHTTPRequestError.errorGettingResponse
        }

//        print("Status Code: \(httpResponse.statusCode)")  // Debugging line
//        print("Response Headers: \(httpResponse.allHeaderFields)")  // Debugging line

        guard httpResponse.statusCode == 200 else {
            let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
            print("HTTP Status Code: \(httpResponse.statusCode) - Response Body: \(responseBody)")
            logger.error("Error while sending the request", metadata: ["status": "\(httpResponse.statusCode)", "responseBody": "\(responseBody)"])
            throw URLError(.badServerResponse)
        }
        
        logger.debug("Request sent successfully")
        logger.trace("Exiting performRequest()")
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
    
    /// Determines the MIME type based on a file's extension.
    ///
    /// - Parameter filename: The filename to determine the MIME type for.
    /// - Returns: A string representing the MIME type.
    private static func mimeType(for filename: String) -> String {
        let suffix = filename.split(separator: ".").last?.lowercased() ?? ""
        switch suffix {
            case "png": return "image/png"
            case "jpeg", "jpg": return "image/jpeg"
            case "webp": return "image/webp"
            default: return "application/octet-stream"
        }
    }
}
