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
    ///   - repository: The decentralized identifier (DID) or handle of the repository.
    ///   - collection: The Namespaced Identifier (NSID) of the repository.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    ///   - isArrayReverse: Indicates whether the list of records is listed in reverse. Optional.
    /// - Returns: An array of records, with an optional cursor to extend the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func listRecords(
        from repository: String,
        collection: String,
        limit: Int? = 50,
        cursor: String? = nil,
        isArrayReverse: Bool? = nil
    ) async throws -> ComAtprotoLexicon.Repository.ListRecordsOutput {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.repo.listRecords") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("repo", repository))

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

            let request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: nil
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Repository.ListRecordsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
