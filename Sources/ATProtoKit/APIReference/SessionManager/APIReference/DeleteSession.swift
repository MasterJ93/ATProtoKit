//
//  DeleteSession.swift
//
//
//  Created by Christopher Jr Riley on 2024-08-18.
//

import Foundation

extension ATProtocolConfiguration {

    /// Refreshes the user's session using a refresh token.
    ///
    /// - Note: According to the AT Protocol specifications: "Delete the current session.
    /// Requires auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.deleteSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/deleteSession.json
    ///
    /// - Parameters:
    ///   - accessToken: The access token for the session.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func deleteSession(
        using accessToken: String,
        pdsURL: String? = nil
    ) async throws {
        guard let sessionURL = pdsURL != nil ? pdsURL : self.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.deleteSession") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                authorizationValue: "Bearer \(accessToken)"
            )

            _ = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: nil
            )
        } catch {
            throw error
        }
    }
}
