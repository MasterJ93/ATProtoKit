//
//  GetSession.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-29.
//

import Foundation

extension ATProtoKit {
    // This doesn't work at the moment.
    public func getSession() async throws -> Result<UserSession, Error> {
        guard let pdsURL = session.pdsURL, let url = URL(string: "\(pdsURL)/xrpc/com.atproto.server.getSession") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let request = APIClientService.createRequest(forRequest: url, andMethod: .get)

        do {
            let response = try await APIClientService.sendRequest(request, decodeTo: UserSession.self)

            return .success(response)
        } catch {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Error: \(error)"]))
        }
    }
}
