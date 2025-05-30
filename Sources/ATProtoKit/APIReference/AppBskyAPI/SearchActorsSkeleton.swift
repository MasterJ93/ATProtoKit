//
//  SearchActorsSkeleton.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-17.
//

import Foundation

extension ATProtoKit {

    /// Retrieves the skeleton results of actors (users).
    ///  
    /// - Note: `viewerDID` will be ignored in public or unauthenticated queries.
    ///
    /// - Note: According to the AT Protocol specifications: "Backend Actors (profile) search,
    /// returns only skeleton."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.searchActorsSkeleton`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/searchActorsSkeleton.json
    ///
    /// - Parameters:
    ///   - query: The string used for searching the users.
    ///   - viewerDID: The decentralized identifier (DID) of account making the request for
    ///   boosting followed accounts in rankings.
    ///   - canTypeAhead: Indicates whether the results can be typed ahead. Optional.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `25`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of actors, with an optional cursor to expand the array. The output
    /// may also display the number of search results.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func searchActorsSkeleton(
        matching query: String,
        viewerDID: String? = nil,
        canTypeAhead: Bool?,
        limit: Int? = 25,
        cursor: String? = nil
    ) async throws -> AppBskyLexicon.Unspecced.SearchActorsSkeletonOutput {
        guard self.pdsURL != "" else {
            throw ATRequestPrepareError.emptyPDSURL
        }

        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/app.bsky.unspecced.searchActorsSkeleton") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("q", query))

        if let viewerDID {
            queryItems.append(("viewer", viewerDID))
        }

        if let canTypeAhead {
            queryItems.append(("typeAhead", "\(canTypeAhead)"))
        }

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

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
                authorizationValue: nil
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Unspecced.SearchActorsSkeletonOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
