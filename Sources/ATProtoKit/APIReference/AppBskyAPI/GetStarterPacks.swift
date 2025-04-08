//
//  GetStarterPacks.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-29.
//

import Foundation

extension ATProtoKit {

    /// Gets an array of starter packs.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get views for a list of starter packs."
    /// 
    /// - SeeAlso: This is based on the [`app.bsky.graph.getStarterPacks`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getStarterPacks.json
    /// 
    /// - Parameter uris: An array of URIs for the starter packs.
    /// - Returns: An array of starter pack records that match the specific URIs in the query.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getStarterPacks(uris: [String]) async throws -> AppBskyLexicon.Graph.GetStarterPacksOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.getStarterPacks") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        let cappedURIArray = uris.prefix(25)
        queryItems += cappedURIArray.map { ("uris", $0) }

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
                decodeTo: AppBskyLexicon.Graph.GetStarterPacksOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
