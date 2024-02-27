//
//  UpdateEmail.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-27.
//

import Foundation

extension ATProtoKit {
    /// Updates the email address associated with the user's account.
    ///
    public func updateEmail(_ email: String, token: String? = nil) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/om.atproto.server.updateEmail") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"])
        }

        let requestBody = ServerUpdateEmail(email: email, token: token)

        do {
            let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .post, acceptValue: nil, contentTypeValue: "application/json", authorizationValue: "Bearer \(session.accessToken)")

            try await APIClientService.sendRequest(request, withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
