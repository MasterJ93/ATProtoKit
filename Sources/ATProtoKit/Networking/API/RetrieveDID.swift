//
//  RetrieveDID.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-27.
//

import Foundation

extension ATProtoKit {
    public static func retrieveDID(from handle: String, pdsURL: String) async throws -> Result<ResolveHandleOutput, Error> {
        // Go to AT Protocol to find the handle in order to see if it exists.
        guard let url = URL(string: "\(pdsURL)/xrpc/com.atproto.identity.resolveHandle") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"]))
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "handle", value: handle)]

        guard let queryURL = components?.url else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid queryURL"]))
        }

        print("Request URL: \(queryURL.absoluteString)")  // Debugging line

        var request = URLRequest(url: queryURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            print("Status Code: \(httpResponse.statusCode)")  // Debugging line
            print("Response Headers: \(httpResponse.allHeaderFields)")  // Debugging line

            if httpResponse.statusCode == 400 {
                print("Request failed. Error code 400.")
                return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Request failed."]))
            }

            let decodedResponse = try JSONDecoder().decode(ResolveHandleOutput.self, from: data)
            print("Decoded Response.did: \(decodedResponse)")
            return .success(decodedResponse)
        } catch (let error) {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Error: \(error)"]))
        }
    }
}
