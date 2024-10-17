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
    /// - Important: If the email has already been confirmed, then `token` must be used.
    /// `token` can be retrieved by sending an email to the confirmed email address
    /// using ``requestEmailUpdate()``.
    ///
    /// - Note: According to the AT Protocol specifications: "Update an account's email."
    /// 
    /// - SeeAlso: This is based on the [`com.atproto.server.updateEmail`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/updateEmail.json
    /// 
    /// - Parameters:
    ///   - email: The new email addtess the user wants to associate with their account.
    ///   - isEmailAuthenticationFactorEnabled: Indicates whether
    ///   Two-Factor Authentication (via email) is enabled. Optional.
    ///   - token: The token used to confirm the change. Optional.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func updateEmail(
        _ email: String,
        isEmailAuthenticationFactorEnabled: Bool? = nil,
        token: String? = nil
    ) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }
        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.updateEmail") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Server.UpdateEmailRequestBody(
            email: email,
            isEmailAuthenticationFactorEnabled: isEmailAuthenticationFactorEnabled,
            token: token
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: nil,
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )

            try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
