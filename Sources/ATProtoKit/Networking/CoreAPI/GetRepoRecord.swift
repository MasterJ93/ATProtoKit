//
//  GetRepoRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-08.
//

import Foundation

extension ATProtoKit {
    /// Searches for and validates a record from the repository.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get a single record from a
    /// repository. Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.getRecord`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/getRecord.json
    ///
    /// - Parameters:
    ///   - recordQuery: The record object.
    ///   - pdsURL: The URL of the Personal Data Server (PDS).
    /// - Returns: A `Result`, which either contains a ``RecordOutput``
    /// if successful, and an `Error` if not.
    public func getRepositoryRecord(from recordQuery: RecordQuery, pdsURL: String? = nil) async throws -> Result<RecordOutput, Error> {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.getRecord") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [
            ("repo", recordQuery.repo),
            ("collection", recordQuery.collection),
            ("rkey", recordQuery.recordKey)
        ]

        if let cid = recordQuery.recordCID {
            queryItems.append(("cid", cid))
        }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: RecordOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
