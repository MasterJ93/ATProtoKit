//
//  ResetPassword.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-26.
//

import Foundation

extension ATProtoKit {

    /// Resets the user's account password.
    /// 
    /// - Note: This doesn't reset the App Password.
    /// 
    /// - Note: According to the AT Protocol specifications: "Reset a user account password using
    /// a token."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.resetPassword`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/resetPassword.json
    ///
    /// - Parameters:
    ///   - token: The token used to reset the password.
    ///   - newPassword: The new password for the user's account.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func resetPassword(
        using token: String,
        newPassword: String,
        pdsURL: String? = nil
    ) async throws {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.resetPassword") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Server.ResetPasswordRequestBody(
            token: token,
            newPassword: newPassword
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: nil,
                contentTypeValue: "application/json",
                authorizationValue: nil
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
