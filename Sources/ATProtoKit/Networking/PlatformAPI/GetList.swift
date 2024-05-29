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
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   result. Optional.
    /// - Returns: A `Result`, containing either a ``GraphGetListOutput``
    /// if successful, or an `Error` if not.
    public func getList(
        from listURI: String,
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> Result<GraphGetListOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.getList") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
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

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: GraphGetListOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
