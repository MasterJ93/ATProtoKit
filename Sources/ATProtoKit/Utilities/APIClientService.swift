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

    static func sendBinaryRequest<T: Decodable>(_ request: URLRequest, binaryData: Data, decodeTo: T.Type) async throws -> T {
        var urlRequest = request
        urlRequest.httpBody = binaryData // Directly setting binary data as the HTTP body

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        // Similar response handling as in sendRequest
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    static func uploadBlob(pdsURL: String = "https://bsky.social", accessToken: String, filename: String, imageData: Data) async throws -> UploadBlobOutput {
         guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.repo.uploadBlob") else {
             throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
         }
        let mimeType = mimeType(for: filename)
        let requestURL = pdsURL.appendingPathComponent("/xrpc/com.atproto.repo.uploadBlob")
        var request = createRequest(forRequest: requestURL, andMethod: .post, contentTypeValue: mimeType, authorizationValue: "Bearer \(accessToken)")
        request.httpBody = imageData

        return try await sendRequest(request, decodeTo: UploadBlobOutput.self)
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
