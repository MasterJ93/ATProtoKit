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
    ///   - repository: The repository that owns the record.
    ///   - collection: The Namespaced Identifier (NSID) of the record.
    ///   - recordKey: The record key of the record.
    ///   - recordCID: The CID hash of the record. Optional.
    ///   - pdsURL: The URL of the Personal Data Server (PDS).
    /// - Returns: A `Result`, which either contains a ``ComAtprotoLexicon/Repository/GetRecordOutput``
    /// if successful, and an `Error` if not.
    public func getRepositoryRecord(
        from repository: String,
        collection: String,
        recordKey: String,
        recordCID: String? = nil,
        pdsURL: String? = nil
    ) async throws -> Result<ComAtprotoLexicon.Repository.GetRecordOutput, Error> {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.getRecord") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [
            ("repo", repository),
            ("collection", collection),
            ("rkey", recordKey)
        ]

        if let recordCID {
            queryItems.append(("cid", recordCID))
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
                                                                  decodeTo: ComAtprotoLexicon.Repository.GetRecordOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
