//
//  ComAtprotoServerRefreshSessionMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-04.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Refreshes the user's session using a refresh token.
    ///
    /// It's best to use ``ATProtocolConfiguration`` or another ``SessionConfiguration``-conforming
    /// `class` instead of using this method directly. If you're making a `class` that conforms to
    /// ``SessionConfiguration``, be sure to use this with the method used for refreshing
    /// a session.
    ///
    /// - Note: According to the AT Protocol specifications: "Refresh an authentication session.
    /// Requires auth using the 'refreshJwt' (not the 'accessJwt')."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.refreshSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/refreshSession.json
    ///
    /// - Parameter refreshToken: The refresh token for the session.
    /// - Returns: An instance of an authenticated user session within the AT Protocol. It may also
    /// have logging information, as well as the URL of the Personal Data Server (PDS).
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func refreshSession(refreshToken: String) async throws -> ComAtprotoLexicon.Server.RefreshSessionOutput {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.server.refreshSession") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = apiClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         authorizationValue: "Bearer \(refreshToken)")
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Server.RefreshSessionOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
