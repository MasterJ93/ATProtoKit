//
//  ListRepos.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-14.
//

import Foundation

extension ATProtoKit {
    /// Lists all decentralized identifiers (DIDs), revisions, and commit CID hashes for all of the outputted repositiories.
    /// 
    /// - Parameters:
    ///   - limit: The number of repositories that can be in the list. Optional. Defaults to `500`.
    ///   - cursor: The mark used to indicate the starting point for the next set of results. Optional.
    ///   - pdsURL: The URL of the Personal Data Service (PDS). Defaults to `https://bsky.social`.
    /// - Returns: A `Result`, containing either a ``SyncListReposOutput`` if successful, or an `Error` if not.
    public static func listRepos(limit: Int? = 500, cursor: String? = nil, pdsURL: String = "https://bsky.social") async throws -> Result<SyncListReposOutput, Error> {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.sync.getRepos") else {
            return .failure(ATURIError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        if let limit {
            let finalLimit = min(1, max(limit, 1000))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request, decodeTo: SyncListReposOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
