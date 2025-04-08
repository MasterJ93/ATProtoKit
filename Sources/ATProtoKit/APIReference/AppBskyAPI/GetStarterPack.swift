//
//  GetStarterPack.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-29.
//

import Foundation

extension ATProtoKit {

    /// Gets a starter pack.
    /// 
    /// - SeeAlso: This is based on the [`app.bsky.graph.getStarterPack`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getStarterPack.json
    /// 
    /// - Parameter uri: The URI of the starter pack record.
    /// - Returns: A starter pack record that matches the URI from the query.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getStarterPack(uri: String) async throws -> AppBskyLexicon.Graph.GetStarterPackOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.getStarterPack") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("starterPack", uri))

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Graph.GetStarterPackOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
