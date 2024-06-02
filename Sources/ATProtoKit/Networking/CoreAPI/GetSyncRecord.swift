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
    ///   - repository: The repository that owns the record.
    ///   - collection: The Namespaced Identifier (NSID) of the record.
    ///   - recordKey: The record key of the record.
    ///   - recordCID: The CID hash of the record. Optional.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: A `Result`, containing either a `Data` object
    /// if successful, or an `Error` if not.
    public func getSyncRecord(
        from repository: String,
        collection: String,
        recordKey: String,
        recordCID: String? = nil,
        pdsURL: String? = nil
    ) async throws -> Result<Data, Error> {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.sync.getRecord") else {
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
