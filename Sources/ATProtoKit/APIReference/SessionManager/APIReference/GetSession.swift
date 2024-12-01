//
//  GetSession.swift
//
//
//  Created by Christopher Jr Riley on 2024-08-18.
//

import Foundation

extension ATProtocolConfiguration {

    /// Fetches an existing session using an access token.
    ///
    /// - Note: According to the AT Protocol specifications: "Get information about the current
    /// auth session. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.getSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/getSession.json
    ///
    /// - Parameters:
    ///   - accessToken: The access token for the session.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: An instance of the session-related information what contains a session response
    /// within the AT Protocol.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSession(
        by accessToken: String,
        pdsURL: String? = nil
    ) async throws -> UserSession {
        guard let sessionURL = pdsURL != nil ? pdsURL : self.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.getSession") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                authorizationValue: "Bearer \(accessToken)"
            )
            var response = try await APIClientService.shared.sendRequest(
                request,
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
