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
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://api.bsky.app`.
    /// - Returns: The record itself, as well as its URI and CID.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getRepositoryRecord(
        from repository: String,
        collection: String,
        recordKey: String,
        recordCID: String? = nil,
        pdsURL: String = "https://api.bsky.app"
    ) async throws -> ComAtprotoLexicon.Repository.GetRecordOutput {
        let finalPDSURL = self.determinePDSURL(customPDSURL: pdsURL)

        guard let requestURL = URL(string: "\(finalPDSURL)/xrpc/com.atproto.repo.getRecord") else {
            throw ATRequestPrepareError.invalidRequestURL
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

            let request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                authorizationValue: nil
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Repository.GetRecordOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
