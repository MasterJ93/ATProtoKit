//
//  GetLists.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-10.
//

import Foundation

extension ATProtoKit {

    /// Retrieves the lists created by the user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates the lists created by a
    /// specified account (actor)."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getLists`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getLists.json
    ///
    /// - Parameters:
    ///   - actorDID: The decentralized identifier (DID) of the user account.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   result. Optional.
    /// - Returns: A `Result`, containing either a
    /// ``AppBskyLexicon/Graph/GetListsOutput``
    /// if successful, or an `Error` if not.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getLists(
        from actorDID: String,
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> Result<AppBskyLexicon.Graph.GetListsOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.getLists") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        queryItems.append(("actor", actorDID))

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

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: AppBskyLexicon.Graph.GetListsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
