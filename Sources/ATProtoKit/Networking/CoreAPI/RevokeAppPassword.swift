//
//  RevokeAppPassword.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-27.
//

import Foundation

extension ATProtoKit {
    /// Revokes an App Password from a user's account.
    /// 
    /// - Parameter appPasswordName: The name associated with the App Password.
    public func revokeAppPassword(named appPasswordName: String) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.revokeAppPassword") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"])
        }

        let requestBody = ServerRevokeAppPassword(appPasswordName: appPasswordName)

        do {
            let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .post, acceptValue: nil, contentTypeValue: "application/json", authorizationValue: "Bearer \(session.accessToken)")

            try await APIClientService.sendRequest(request, withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
