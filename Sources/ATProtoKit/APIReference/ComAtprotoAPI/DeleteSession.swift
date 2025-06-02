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
    /// It's best to use ``ATProtocolConfiguration`` or another ``SessionConfiguration``-conforming
    /// `class` instead of using this method directly. If you're making a `class` that conforms to
    /// ``SessionConfiguration``, be sure to use this with the method used for deleting a session.
    ///
    /// - Note: According to the AT Protocol specifications: "Delete the current session.
    /// Requires auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.deleteSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/deleteSession.json
    ///
    /// - Parameter refreshToken: The refresh token for the session.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func deleteSession(
        refreshToken: String
    ) async throws {
        guard self.pdsURL != "" else {
            throw ATRequestPrepareError.emptyPDSURL
        }

        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.server.deleteSession") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = apiClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         authorizationValue: "Bearer \(refreshToken)")

            _ = try await apiClientService.sendRequest(
                request
            )
        } catch {
            throw error
        }
    }
}
