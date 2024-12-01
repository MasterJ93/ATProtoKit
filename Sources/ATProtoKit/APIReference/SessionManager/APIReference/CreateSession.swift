//
//  CreateSession.swift
//
//
//  Created by Christopher Jr Riley on 2024-08-18.
//

import Foundation

extension ATProtocolConfiguration {

    /// Attempts to authenticate the user into the server.
    ///
    /// If the user has Two-Factor Authentication enabled, then `authenticationFactorToken`
    /// is required to be used. If the user is inputting their App Password, then the parameter
    /// shouldn't be used.
    ///
    /// - Note: According to the AT Protocol specifications: "Handle or other identifier supported
    /// by the server for the authenticating user."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createSession.json
    ///
    /// - Parameter authenticationFactorToken: A token used for
    /// Two-Factor Authentication. Optional.
    /// - Returns: An instance of an authenticated user session within the AT Protocol. It may also
    /// have logging information, as well as the URL of the Personal Data Server (PDS).
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func authenticate(authenticationFactorToken: String? = nil) async throws -> UserSession {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.server.createSession") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let credentials = ComAtprotoLexicon.Server.CreateSessionRequestBody(
            identifier: handle,
            password: appPassword,
            authenticationFactorToken: authenticationFactorToken
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post
            )
            var response = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: credentials,
                decodeTo: UserSession.self
            )

            response.pdsURL = self.pdsURL
            response.logger = await ATProtocolConfiguration.getLogger()

            if self.maxRetryCount != nil {
                response.maxRetryCount = self.maxRetryCount
            }

            if self.retryTimeDelay != nil {
                response.retryTimeDelay = self.retryTimeDelay
            }

            return response
        } catch {
            throw error
        }
    }
}
