//
//  AppBskyUnspeccedGetConfigMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-30.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Retrieves some runtime configuration.
    /// 
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get miscellaneous
    /// runtime configuration."
    /// 
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getConfig`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getConfig.json
    /// 
    /// - Returns: Various additional information about the user account.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getConfiguration() async throws -> AppBskyLexicon.Unspecced.GetConfigOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getConfig") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let queryItems = [(String, String)]()

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Unspecced.GetConfigOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
