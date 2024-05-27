//
//  ListRecords.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-11.
//

import Foundation

extension ATProtoKit {

    /// Lists a collection's records within a respository.
    /// 
    /// - Note: According to the AT Protocol specifications: "List a range of records in a
    /// repository, matching a specific collection. Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.listRecords`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/listRecords.json
    ///
    /// - Parameters:
    ///   - repositoryDID: The decentralized identifier (DID) or handle of the repository.
    ///   - collection: The Namespaced Identifier (NSID) of the repository.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   result. Optional.
    ///   - isArrayReverse: Indicates whether the list of records is listed in reverse. Optional.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: A `Result`, containing ``RepoListRecordsOutput``
    /// if successful, or an `Error` if not.
    public func listRecords(from repositoryDID: String, collection: String, limit: Int? = 50, cursor: String? = nil, isArrayReverse: Bool? = nil,
                            pdsURL: String? = nil) async throws -> Result<RepoListRecordsOutput, Error> {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.listRecords") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        queryItems.append(("repo", repositoryDID))

        queryItems.append(("collection", collection))

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        if let isArrayReverse {
            queryItems.append(("reverse", "\(isArrayReverse)"))
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
                                                                  decodeTo: RepoListRecordsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
