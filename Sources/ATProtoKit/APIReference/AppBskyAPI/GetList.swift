//
//  GetList.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-09.
//

import Foundation

extension ATProtoKit {

    /// Grabs a given list.
    /// 
    /// - Note: According to the AT Protocol specifications: "Gets a 'view' (with additional
    /// context) of a specified list."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getList`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getList.json
    ///
    /// - Parameters:
    ///   - listURI: The URI of the list.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of list items, the metadata of the list itself, and an optional cursor
    /// to extend the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getList(
        from listURI: String,
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> AppBskyLexicon.Graph.GetListOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.serviceEndpoint,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.getList") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("list", listURI))

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

            let request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Graph.GetListOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
