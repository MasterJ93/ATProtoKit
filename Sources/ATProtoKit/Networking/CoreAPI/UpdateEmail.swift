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
    /// - Important: If the email has already been confirmed, then `token` must be used. `token` can be retrieved by sending an email to the confirmed email address using ``requestEmailUpdate()``.
    ///
    /// - Parameters:
    ///   - email: The new email addtess the user wants to associate with their account.
    ///   - token: The token used to confirm the change. Optional.
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
