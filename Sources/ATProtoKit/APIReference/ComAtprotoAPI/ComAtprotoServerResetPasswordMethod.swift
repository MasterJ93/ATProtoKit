//
//  ComAtprotoServerResetPasswordMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
    ///   - resetToken: The token used to reset the password.
    ///   - newPassword: The new password for the user's account.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func resetPassword(
        using resetToken: String,
        newPassword: String
    ) async throws {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.server.resetPassword") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Server.ResetPasswordRequestBody(
            resetToken: resetToken,
            newPassword: newPassword
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: nil,
                contentTypeValue: "application/json",
                authorizationValue: nil
            )

            _ = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
