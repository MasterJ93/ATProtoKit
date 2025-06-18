//
//  ComAtprotoServerGetSessionMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-04.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Gets the session information for the user account.
    /// 
    /// It's best to use ``ATProtocolConfiguration`` or another ``SessionConfiguration``-conforming
    /// `class` instead of using this method directly. If you're making a `class` that conforms to
    /// ``SessionConfiguration``, be sure to use this with the method used for getting a session.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get information about the current
    /// auth session. Requires auth."
    /// 
    /// - SeeAlso: This is based on the [`com.atproto.server.getSession`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/getSession.json
    ///
    /// - Parameter accessToken: The access token used for API requests that requests authentication.
    ///
    /// - Returns: An instance of the session-related information for the user account.
    /// 
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSession(
        by accessToken: String
    ) async throws -> ComAtprotoLexicon.Server.GetSessionOutput {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.server.getSession") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Server.GetSessionOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
