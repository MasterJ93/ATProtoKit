//
//  RequestPasswordReset.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-26.
//

import Foundation

extension ATProtoKit {

    /// Sends an email containing a way to reset the user's password.
    /// 
    /// - Note: This is resetting the main password, not the App Password.
    /// 
    /// - Note: According to the AT Protocol specifications: "Initiate a user account password
    /// reset via email."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.requestPasswordReset`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/requestPasswordReset.json
    ///
    /// - Parameter email: The email associated with the user's account.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func requestPasswordReset(forEmail email: String) async throws {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.server.requestPasswordReset") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Server.RequestPasswordResetRequestBody(
            email: email
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: nil,
                contentTypeValue: "application/json",
                authorizationValue: nil
            )

            _ = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
