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
    ///   - repositoryDID: The repository's decentralized identifiers (DID) that owns the record.
    ///   - collection: The Namespaced Identifier (NSID) of the record.
    ///   - recordKey: The record key of the record.
    ///   - recordCID: The CID hash of the record. Optional.
    /// - Returns: A .car file, containing CBOR-encoded data of a record.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSyncRecord(
        from repositoryDID: String,
        collection: String,
        recordKey: String,
        recordCID: String? = nil
    ) async throws -> Data {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.sync.getRecord") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [
            ("repo", repositoryDID),
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

            let request = await APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/vnd.ipld.car",
                contentTypeValue: nil,
                authorizationValue: nil
            )
            let response = try await APIClientService.shared.sendRequest(request)

            return response
        } catch {
            throw error
        }
    }
}
