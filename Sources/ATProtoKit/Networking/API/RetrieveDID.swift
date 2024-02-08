//
//  RetrieveDID.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-27.
//

import Foundation

extension ATProtoKit {
    public static func retrieveDID(from handle: String, pdsURL: String = "https://bsky.social") async throws -> Result<ResolveHandleOutput, Error> {
        // Go to AT Protocol to find the handle in order to see if it exists.
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.identity.resolveHandle") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"]))
        }

        var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "handle", value: handle)]

        do {
            let queryURL = try await APIClientService.setQueryItems(
                for: requestURL,
                with: [
                    "handle" : handle
                ])

            print("Request URL: \(queryURL.absoluteString)")  // Debugging line

            let request = APIClientService.createRequest(forRequest: queryURL, andMethod: .get)

            let response = try await APIClientService.sendRequest(request, decodeTo: ResolveHandleOutput.self)

            return .success(response)
        } catch (let error) {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Error: \(error)"]))
        }
    }
}
