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

        let request = APIClientService.createRequest(forRequest: queryURL, andMethod: .get)

        do {
            let response = try await APIClientService.sendRequest(request, decodeTo: ResolveHandleOutput.self)

            return .success(response)
        } catch (let error) {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Error: \(error)"]))
        }
    }
}
