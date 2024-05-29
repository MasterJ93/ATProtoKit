//
//  GetSyncRecord.swift
//  
//
//  Created by Christopher Jr Riley on 2024-02-18.
//

import Foundation

extension ATProtoKit {

    /// Gets a record as a .car format.
    ///
    /// - Note: According to the AT Protocol specifications: "Get data blocks needed to prove the
    /// existence or non-existence of record in the current version of repo. Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.getRecord`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/getRecord.json
    ///
    /// - Parameters:
    ///   - recordQuery: The information required to get a record.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: A `Result`, containing either a `Data` object
    /// if successful, or an `Error` if not.
    public func getSyncRecord(
        _ recordQuery: RecordQuery,
        pdsURL: String? = nil
    ) async throws -> Result<Data, Error> {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.sync.getRecord") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let queryItems = [
            ("repo", recordQuery.repo),
            ("collection", recordQuery.collection),
            ("rkey", recordQuery.recordKey)
        ]

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/vnd.ipld.car",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
