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

    static func createRequest(forRequest requestURL: URL, andMethod httpMethod: HTTPMethod, contentTypeValue: String = "application/json", authorizationValue: String? = nil) -> URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = httpMethod.rawValue

        if let authorizationValue {
            request.addValue(authorizationValue, forHTTPHeaderField: "Authorization")
        }
        request.addValue(contentTypeValue, forHTTPHeaderField: "Content-Type")
        return request
    }

    static func encode<T: Encodable>(_ jsonData: T) async throws -> Data {
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonData) else { throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Error encoding request body"]) }
        return httpBody
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

    // Same method as above, but sending raw JSON instead.
    static func sendRequestWithRawJSONOutput<T: Decodable>(_ request: URLRequest, withEncodingBody body: Encodable? = nil, decodeTo: T.Type) async throws -> [String: Any] {
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

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
}
