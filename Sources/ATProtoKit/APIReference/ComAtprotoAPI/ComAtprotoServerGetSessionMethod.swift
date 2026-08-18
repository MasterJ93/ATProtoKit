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
    /// Call this method on an `ATProtoKit` client created with ``ATProtocolConfiguration``,
    /// ``ATOAuthSessionConfiguration``, or another ``SessionConfiguration`` implementation. The
    /// configured session supplies the appropriate authorization without exposing its token to
    /// this lexicon method.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get information about the current
    /// auth session. Requires auth."
    /// 
    /// - SeeAlso: This is based on the [`com.atproto.server.getSession`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/getSession.json
    ///
    /// - Returns: An instance of the session-related information for the user account.
    /// 
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSession() async throws -> ComAtprotoLexicon.Server.GetSessionOutput {
        let serviceEndpoint: URL
        if let session = try await self.getUserSession() {
            serviceEndpoint = session.serviceEndpoint
        } else if let sessionConfiguration,
                  let configuredServiceEndpoint = URL(string: sessionConfiguration.pdsURL) {
            serviceEndpoint = configuredServiceEndpoint
        } else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let requestURL = serviceEndpoint
            .appendingPathComponent("xrpc")
            .appendingPathComponent("com.atproto.server.getSession")
        let request = apiClientService.createRequest(
            forRequest: requestURL,
            andMethod: .get,
            requiresAuthorization: true
        )

        return try await apiClientService.sendRequest(
            request,
            decodeTo: ComAtprotoLexicon.Server.GetSessionOutput.self
        )
    }

    /// Gets the session information for the user account.
    ///
    /// - Parameter accessToken: The legacy access-token argument. This value is ignored because
    /// authorization is supplied by the configured session.
    ///
    /// - Returns: An instance of the session-related information for the user account.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    @available(*, deprecated, renamed: "getSession()")
    public func getSession(
        by accessToken: String
    ) async throws -> ComAtprotoLexicon.Server.GetSessionOutput {
        return try await self.getSession()
    }
}
