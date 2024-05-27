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
    /// The token in the email comes from the result of ``requestEmailConfirmation()``.
    /// The token is simply sent to the user's email: it doesn't appear as the output of that
    /// method's response.
    ///
    /// - Important: `token` is required. Getting `token` requires an email to be sent
    /// to the email address. You can send this email via ``requestEmailConfirmation()``.
    ///
    /// - Note: According to the AT Protocol specifications: "Confirm an email using a token
    /// from com.atproto.server.requestEmailConfirmation."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.confirmEmail`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/confirmEmail.json
    ///
    /// - Parameters:
    ///   - email: The email address to confirm.
    ///   - token: The token used to confirm the email address.
    public func confirmEmail(_ email: String, token: String) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.confirmEmail") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ServerConfirmEmail(
            email: email,
            token: token
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: nil,
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(accessToken)")

            _ = try await APIClientService.sendRequest(request,
                                                       withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
