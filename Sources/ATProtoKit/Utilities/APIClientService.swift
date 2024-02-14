//
//  APIClientService.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-28.
//

import Foundation

/// A helper class to handle the most common HTTP Requests for the AT Protocol.
public class APIClientService {

    private init() {}

    
    /// Creates a `URLRequest` with specified parameters.
    /// - Parameters:
    ///   - requestURL: The URL for the request.
    ///   - httpMethod: The HTTP method to use (GET, POST, PUT, DELETE).
    ///   - acceptValue: The Accept header value, defaults to "application/json".
    ///   - contentTypeValue: The Content-Type header value, defaults to "application/json".
    ///   - authorizationValue: The Authorization header value, optional.
    /// - Returns: A configured URLRequest instance.
    public static func createRequest(forRequest requestURL: URL, andMethod httpMethod: HTTPMethod, acceptValue: String? = "application/json", contentTypeValue: String? = "application/json", authorizationValue: String? = nil) -> URLRequest {
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

        return request
    }

    static func encode<T: Encodable>(_ jsonData: T) async throws -> Data {
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonData) else { throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Error encoding request body"]) }
        return httpBody
    }


    /// Sets query items for a given URL.
    /// - Parameters:
    ///   - requestURL: The base URL to append query items to.
    ///   - queryItems: An array of key-value pairs to be set as query items.
    /// - Returns: A new URL with the query items appended.
    public static func setQueryItems(for requestURL: URL, with queryItems: [(String, String)]) throws -> URL {
        var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: true)

        // Map out each URLQueryItem with the key ($0.0) and value ($0.1) of the item.
        components?.queryItems = queryItems.map { URLQueryItem(name: $0.0, value: $0.1) }

        guard let finalURL = components?.url else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to construct URL with parameters"])
        }
        return finalURL
    }
    
    /// Sends a `URLRequest` and decodes the response to a specified `Decodable` type.
    /// - Parameters:
    ///   - request: The `URLRequest` to send.
    ///   - body: An optional `Encodable` body to be encoded and attached to the request.
    ///   - decodeTo: The type to decode the response into.
    /// - Returns: An instance of the specified `Decodable` type.
    public static func sendRequest<T: Decodable>(_ request: URLRequest, withEncodingBody body: Encodable? = nil, decodeTo: T.Type) async throws -> T {
        var urlRequest = request
        
        // Encode the body to JSON data if it's not nil
        if let body = body {
            do {
                urlRequest.httpBody = try body.toJsonData()
            } catch {
                throw NSError(domain: "APIClientService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error encoding request body"])
            }
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error getting response"])
        }

//        print("Status Code: \(httpResponse.statusCode)")  // Debugging line
//        print("Response Headers: \(httpResponse.allHeaderFields)")  // Debugging line

        guard httpResponse.statusCode == 200 else {
            let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
            print("HTTP Status Code: \(httpResponse.statusCode) - Response Body: \(responseBody)")
            throw URLError(.badServerResponse)
        }

        let decodedData = try JSONDecoder().decode(T.self, from: data)
        print("Decoded data: \(decodedData)")
        return decodedData
    }

    /// Sends a `URLRequest` without expecting a specific decoded response type.
    /// - Parameters:
    ///   - request: The `URLRequest` to send.
    ///   - body: An optional `Encodable` body to be encoded and attached to the request.
    ///   - Note: Since there doesn't seem to be a way to have optional generic types, this method can't be combined with  `sendRequest(_:withEncodingBody:decodeTo:)` and will have to be overloaded until a better solution arrives.
    public static func sendRequest(_ request: URLRequest, withEncodingBody body: Encodable? = nil) async throws {
        var urlRequest = request

        // Encode the body to JSON data if it's not nil
        if let body = body {
            do {
                urlRequest.httpBody = try body.toJsonData()
            } catch {
                throw NSError(domain: "APIClientService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error encoding request body"])
            }
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error getting response"])
        }

//        print("Status Code: \(httpResponse.statusCode)")  // Debugging line
//        print("Response Headers: \(httpResponse.allHeaderFields)")  // Debugging line

        guard httpResponse.statusCode == 200 else {
            let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
            print("HTTP Status Code: \(httpResponse.statusCode) - Response Body: \(responseBody)")
            throw URLError(.badServerResponse)
        }
    }
    
    /// Uploads a blob to a specified URL with multipart/form-data encoding.
    /// - Parameters:
    ///   - pdsURL: The base URL for the blob upload.
    ///   - accessToken: The access token for authorization.
    ///   - filename: The filename of the blob to upload.
    ///   - imageData: The data of the blob to upload.
    /// - Returns: A `BlobContainer` instance with the upload result.
    public static func uploadBlob(pdsURL: String = "https://bsky.social", accessToken: String, filename: String, imageData: Data) async throws -> BlobContainer {
         guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.repo.uploadBlob") else {
             throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
         }
        let mimeType = mimeType(for: filename)

        do {
            var request = createRequest(forRequest: requestURL, andMethod: .post, contentTypeValue: mimeType, authorizationValue: "Bearer \(accessToken)")
            request.httpBody = imageData

            return try await sendRequest(request, decodeTo: BlobContainer.self)
        } catch {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Response"])
        }
    }

    /// Sends a `URLRequest` and returns the raw JSON output as a `Dictionary`.
    /// - Parameters:
    ///   - request: The `URLRequest` to send.
    ///   - body: An optional `Encodable` body to be encoded and attached to the request.
    /// - Returns: A `Dictionary` representation of the JSON response.
    public static func sendRequestWithRawJSONOutput(_ request: URLRequest, withEncodingBody body: Encodable? = nil) async throws -> [String: Any] {
        var urlRequest = request

        // Encode the body to JSON data if it's not nil
        if let body = body {
            do {
                urlRequest.httpBody = try body.toJsonData()
            } catch {
                throw NSError(domain: "APIClientService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error encoding request body"])
            }
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error getting response"])
        }

        guard httpResponse.statusCode == 200 else {
            let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
            print("HTTP Status Code: \(httpResponse.statusCode) - Response Body: \(responseBody)")
            throw URLError(.badServerResponse)
        }

        guard let response = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] else { return ["Response": "No response"] }
        return response
    }

    /// Sends a `URLRequest` and returns the raw HTML output as a `String`.
    /// - Parameters:
    ///   - request: The `URLRequest` to send.
    /// - Returns: A `String` representation of the HTML response.
    public static func sendRequestWithRawHTMLOutput(_ request: URLRequest) async throws -> String {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "APIClientService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error getting response"])
        }

        guard httpResponse.statusCode == 200 else {
            let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
            print("HTTP Status Code: \(httpResponse.statusCode) - Response Body: \(responseBody)")
            throw URLError(.badServerResponse)
        }

        guard let htmlString = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "APIClientService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode HTML"])
        }

        return htmlString
    }

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
