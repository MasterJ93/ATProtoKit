//
//  ConfirmEmail.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-23.
//

import Foundation

extension ATProtoKit {
    /// Confirms an email by the user using the token that was sent to the user's email inbox.
    ///
    /// The token in the email comes from the result of ``requestEmailConfirmation``. The token is simply sent to the user's email: it doesn't appear as the output of that method's response.
    public func confirmEmail(_ email: String, token: String) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.confirmEmail") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"])
        }

        let requestBody = ServerConfirmEmail(email: email, token: token)

        do {
            let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .post, acceptValue: nil, contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
