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
    /// - Note: According to the AT Protocol specifications: "Enumerates all the DID, rev, and commit CID for all repos hosted by this service. Does not require auth; implemented by PDS and Relay."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.listRepos`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/listRepos.json
    ///
    /// - Parameters:
    ///   - limit: The number of repositories that can be in the list. Optional. Defaults to `500`.
    ///   - cursor: The mark used to indicate the starting point for the next set of results. Optional.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: A `Result`, containing either a ``SyncListReposOutput`` if successful, or an `Error` if not.
    public func listRepos(limit: Int? = 500, cursor: String? = nil,
                          pdsURL: String? = nil) async throws -> Result<SyncListReposOutput, Error> {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.sync.getRepos") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
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

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: SyncListReposOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
