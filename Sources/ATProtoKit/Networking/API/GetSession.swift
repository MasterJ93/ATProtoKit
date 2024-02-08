//
//  GetSession.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-29.
//

import Foundation

extension ATProtoKit {
    public static func getSession(byAccessToken accessJWT: String, pdsURL: String = "https://bsky.social") async throws -> Result<SessionResponse, Error> {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.server.getSession") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .get, authorizationValue: "Bearer \(accessJWT)")

        do {
            let response = try await APIClientService.sendRequest(request, decodeTo: SessionResponse.self)
            return .success(response)
        } catch {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Error: \(error)"]))
        }
    }
}
