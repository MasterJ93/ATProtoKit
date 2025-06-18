//
//  ComAtprotoSyncListBlobsMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Lists a user account's blob CID hashes.
    /// 
    /// - Note: According to the AT Protocol specifications: "List blob CIDs for an account,
    /// since some repo revision. Does not require auth; implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.listBlobs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/listBlobs.json
    ///
    /// - Parameters:
    ///   - repositoryDID: The decentralized identifier (DID) or handle of the repository.
    ///   - sinceRevision: The revision of the repository to list blobs starting from. Optional.
    ///   - limit: The number of invite codes in the list. Optional. Defaults to `500`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of CID hashes from a user account, with an optional cursor to extend
    /// the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func listBlobs(
        from repositoryDID: String,
        sinceRevision: String?,
        limit: Int? = 500,
        cursor: String? = nil
    ) async throws -> ComAtprotoLexicon.Sync.ListBlobsOutput {
        guard let requestURL = URL(string: "https://bsky.network/xrpc/com.atproto.sync.listBlobs") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("did", repositoryDID))

        if let sinceRevision {
            queryItems.append(("since", sinceRevision))
        }

        if let limit {
            let finalLimit = max(1, min(limit, 1_000))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/vnd.ipld.car",
                contentTypeValue: nil,
                authorizationValue: nil
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Sync.ListBlobsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
