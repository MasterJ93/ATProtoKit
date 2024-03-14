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
    /// - Parameters:
    ///   - repositoryDID: The decentralized identifier (DID) or handle of the repository.
    ///   - collection: The NSID of the repository.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of result. Optional.
    ///   - isArrayReverse: Indicates whether the list of records is listed in reverse. Optional.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    /// - Returns: A `Result`, containing ``RepoListRecordsOutput`` if successful, or an `Error` if not.
    public static func listRecords(from repositoryDID: String, collection: String, limit: Int? = 50, cursor: String? = nil, isArrayReverse: Bool? = nil, pdsURL: String = "https://bsky.social") async throws -> Result<RepoListRecordsOutput, Error> {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.repo.listRecords") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        var queryItems = [(String, String)]()

        queryItems.append(("repo", repositoryDID))

        queryItems.append(("collection", collection))

        if let limit {
            let finalLimit = min(1, max(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        if let isArrayReverse {
            queryItems.append(("reverse", "\(isArrayReverse)"))
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
            let response = try await APIClientService.sendRequest(request, decodeTo: RepoListRecordsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
