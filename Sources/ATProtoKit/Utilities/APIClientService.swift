//
//  APIClientService.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-28.
//

import Foundation

extension Encodable {
    func toJsonData() throws -> Data? {
        return try JSONEncoder().encode(self)
    }
}

class APIClientService {

    private init() {}

    static func createRequest(forRequest requestURL: URL, andMethod httpMethod: HTTPMethod, acceptValue: String? = "application/json", contentTypeValue: String? = "application/json", authorizationValue: String? = nil) -> URLRequest {
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

    static func setQueryItems(for requestURL: URL, with queryItems: [(String, String)]) throws -> URL {
        var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: true)

        // Map out each URLQueryItem with the key ($0.0) and value ($0.1) of the item.
        components?.queryItems = queryItems.map { URLQueryItem(name: $0.0, value: $0.1) }

        guard let finalURL = components?.url else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to construct URL with parameters"])
        }
        return finalURL
    }

    static func sendRequest<T: Decodable>(_ request: URLRequest, withEncodingBody body: Encodable? = nil, decodeTo: T.Type) async throws -> T {
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

    // It appears that optional generic types can't really work in methods. Until a better solution arrives, it's probably best to overload the above method.
    static func sendRequest(_ request: URLRequest, withEncodingBody body: Encodable? = nil) async throws {
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

    static func uploadBlob(pdsURL: String = "https://bsky.social", accessToken: String, filename: String, imageData: Data) async throws -> BlobContainer {
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

    // Same method as above, but sending raw JSON instead.
    static func sendRequestWithRawJSONOutput(_ request: URLRequest, withEncodingBody body: Encodable? = nil) async throws -> [String: Any] {
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
    
    /// Represents the HTTP methods used to interact with the AT Protocol.
    enum HTTPMethod: String {
        /// Retrieve information from the AT Protocol using a given URI.
        case get = "GET"
        /// Sends data to the AT Protocol to create or update a resource.
        case post = "POST"
        /// Replaces all current representations of the target resource with the request payload.
        case put = "PUT"
        /// Removes the specified resource(s) from the AT Protocol server.
        case delete = "DELETE"
    }

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
