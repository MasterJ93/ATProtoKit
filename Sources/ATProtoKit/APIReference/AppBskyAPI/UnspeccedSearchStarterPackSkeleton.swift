//
//  UnspeccedSearchStarterPackSkeleton.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-30.
//

import Foundation

extension ATProtoKit {

    /// Retrieves the results of a search query for skeleton starter packs.
    /// 
    /// - Note: According to the AT Protocol specifications: "Backend Starter Pack search,
    /// returns only skeleton."
    /// 
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    /// 
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.searchStarterPacksSkeleton`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/searchStarterPacksSkeleton.json
    /// 
    /// - Parameters:
    ///   - query: The string being searched against. Lucene query syntax recommended.
    ///   - viewerDID: The decentralized identifier (DID) of the requesting account. Optional.
    ///   - limit: - limit: The number of items the list will hold. Optional. Defaults to `25`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of skeleton starter packs, with an optional cursor to expand the array.
    /// The output may also display the total number of search results.
    public func searchStarterPacksSkeleton(
        matching query: String,
        viewerDID: String? = nil,
        limit: Int? = 25,
        cursor: String? = nil
    ) async throws -> AppBskyLexicon.Unspecced.SearchStarterPackSkeletonOutput {
        guard self.pdsURL != "" else {
            throw ATRequestPrepareError.emptyPDSURL
        }

        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/app.bsky.unspecced.searchStarterPacksSkeleton") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("q", query))

        if let viewerDID {
            queryItems.append(("viewer", viewerDID))
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
                decodeTo: AppBskyLexicon.Unspecced.SearchStarterPackSkeletonOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
