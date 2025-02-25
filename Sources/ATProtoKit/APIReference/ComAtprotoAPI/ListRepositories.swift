//
//  ListRepositories.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-14.
//

import Foundation

extension ATProtoKit {

    /// Lists all decentralized identifiers (DIDs), revisions, and commit CID hashes for all of the
    /// outputted repositiories.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates all the DID, rev, and
    /// commit CID for all repos hosted by this service. Does not require auth; implemented by
    /// PDS and Relay."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.listRepos`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/listRepos.json
    ///
    /// - Parameters:
    ///   - limit: The number of repositories that can be in the list. Optional. Defaults to `500`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of repositories, with an optional cursor to extend the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func listRepositories(
        limit: Int? = 500,
        cursor: String? = nil
    ) async throws -> ComAtprotoLexicon.Sync.ListRepositoriesOutput {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.sync.listRepos") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let limit {
            let finalLimit = max(1, min(limit, 1000))
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
                authorizationValue: nil
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Sync.ListRepositoriesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
