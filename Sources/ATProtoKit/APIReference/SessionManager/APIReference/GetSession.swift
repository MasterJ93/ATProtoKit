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
    /// When the method completes, ``ATProtocolConfiguration/session`` will be updated with an
    /// instance of an authenticated user session within the AT Protocol. It may also have logging
    /// information, as well as the URL of the Personal Data Server (PDS).
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
    ) async throws {
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
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: SessionResponse.self
            )

            guard let session = self.session else {
                // TODO: Add a "No session found" error.
                throw ATNSIDError.notEnoughSegments
            }

            var userSession = UserSession(
                handle: response.handle,
                sessionDID: response.sessionDID,
                isEmailAuthenticationFactorEnabled: response.isEmailAuthenticationFactorEnabled,
                accessToken: session.accessToken,
                refreshToken: session.refreshToken,
                isActive: response.isActive,
                status: response.status)

            userSession.pdsURL = session.pdsURL
            userSession.logger = await ATProtocolConfiguration.getLogger()

            if self.maxRetryCount != nil {
                userSession.maxRetryCount = session.maxRetryCount
            }

            if self.retryTimeDelay != nil {
                userSession.retryTimeDelay = session.retryTimeDelay
            }

            self.session = userSession
        } catch {
            throw error
        }
    }
}
