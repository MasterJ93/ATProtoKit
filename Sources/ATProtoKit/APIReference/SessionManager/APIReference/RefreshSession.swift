//
//  RefreshSession.swift
//
//
//  Created by Christopher Jr Riley on 2024-08-18.
//

import Foundation

extension ATProtocolConfiguration {

    /// Refreshes the user's session using a refresh token.
    ///
    /// - Note: According to the AT Protocol specifications: "Refresh an authentication session.
    /// Requires auth using the 'refreshJwt' (not the 'accessJwt')."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.refreshSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/refreshSession.json
    ///
    /// - Parameters:
    ///   - refreshToken: The refresh token for the session.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: An instance of an authenticated user session within the AT Protocol. It may also
    /// have logging information, as well as the URL of the Personal Data Server (PDS).
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func refreshSession(
        using refreshToken: String,
        pdsURL: String? = nil
    ) async throws -> UserSession {
        guard let sessionURL = pdsURL != nil ? pdsURL : self.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.refreshSession") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         authorizationValue: "Bearer \(refreshToken)")
            var response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: UserSession.self
            )
            response.pdsURL = self.pdsURL

            if self.logger != nil {
                response.logger = self.logger
            }

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
