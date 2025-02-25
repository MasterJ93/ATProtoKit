//
//  SearchStarterPacks.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-29.
//

import Foundation

extension ATProtoKit {

    /// Retrieves the results of a search query for starter packs.
    /// 
    /// - Note: According to the AT Protocol specifications: "Find starter packs matching
    /// search criteria. Does not require auth."
    /// 
    /// - SeeAlso: This is based on the [`app.bsky.graph.searchStarterPacks`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/searchStarterPacks.json
    /// 
    /// 
    /// - Parameters:
    ///   - query: The string being searched against. Lucene query syntax recommended.
    ///   - limit: The number of suggested users to follow. Optional. Defaults to `25`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of starter packs, with an optional cursor to expand the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func searchStarterPacks(
        matching query: String,
        limit: Int? = 25,
        cursor: String? = nil
    ) async throws -> AppBskyLexicon.Graph.SearchStarterPacksOutput {
        guard self.pdsURL != "" else {
            throw ATRequestPrepareError.emptyPDSURL
        }

        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/app.bsky.feed.searchStarterPacks") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("q", query))

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
                contentTypeValue: nil
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Graph.SearchStarterPacksOutput.self
            )

            return response

        } catch {
            throw error
        }
    }
}
