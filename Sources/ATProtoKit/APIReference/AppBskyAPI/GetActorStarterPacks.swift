//
//  GetActorStarterPacks.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-29.
//

import Foundation

extension ATProtoKit {

    /// Gets the user account's starter packs.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of starter packs created
    /// by the actor."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getActorStarterPacks`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getActorStarterPacks.json
    ///
    /// - Parameters:
    ///   - actor: The AT Identifier of the user account.
    ///   - limit: limit: The number of suggested users to follow. Optional. Defaults to `50`.
    ///   Can only choose between `1` and `100`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of starter pack records from the given user account.
    /// 
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getActorStarterPacks(
        by actor: String,
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> AppBskyLexicon.Graph.GetActorStarterPacksOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.getActorStarterPack") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("actor", actor))

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = await APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Graph.GetActorStarterPacksOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
