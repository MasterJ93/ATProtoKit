//
//  DeleteSession.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-05.
//

import Foundation

extension ATProtoKit {

    /// Deletes a session from the user account.
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
        accessToken: String,
        pdsURL: String = "https://bsky.social"
    ) async throws {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.server.deleteSession") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         authorizationValue: "Bearer \(accessToken)")

            _ = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Server.RefreshSessionOutput.self
            )
        } catch {
            throw error
        }
    }
}
