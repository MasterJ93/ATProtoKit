//
//  ComAtprotoSyncListReposByCollectionMethod.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-20.
//

import Foundation

extension ATProtoKit {

    /// Enumerates all decentralized identifiers (DIDs) with records in the given collection's
    /// Namespace Identifier (NSID).
    /// 
    /// - Note: According to the AT Protocol specifications: "Enumerates all the DIDs which have
    /// records with the given collection NSID."
    /// 
    /// - SeeAlso: This is based on the [`com.atproto.sync.listReposByCollection`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/listReposByCollection.json
    /// 
    /// - Parameters:
    ///   - collection: The Namespaced Identifier (NSID) of the repository.
    ///   - limit: The number of repositories in the array. Optional. Defaults to `500`. Can only
    ///   choose between `1` and `2,000`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of repositories, with an optional cursor to extend the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func listRepositoriesByCollection(
        collection: String,
        limit: Int? = 500,
        cursor: String? = nil
    ) async throws -> ComAtprotoLexicon.Sync.ListRepositoriesByCollectionOutput {
        guard let requestURL = URL(string: "https://bsky.network/xrpc/com.atproto.sync.listReposByCollection") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("collection", String(collection)))

        if let limit {
            let finalLimit = max(1, min(limit, 2_000))
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
                decodeTo: ComAtprotoLexicon.Sync.ListRepositoriesByCollectionOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
