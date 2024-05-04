//
//  ListBlobs.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-13.
//

import Foundation

extension ATProtoKit {

    /// Lists a user account's blob CID hashes.
    /// 
    /// - Note: According to the AT Protocol specifications: "List blob CIDso for an account,
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
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   results. Optional.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: A `Result`, containing either a ``SyncListBlobsOutput``
    /// if successful, or an `Error` if not.
    public func listBlobs(from repositoryDID: String, sinceRevision: String?, limit: Int? = 500, cursor: String? = nil,
                                 pdsURL: String? = nil) async throws -> Result<SyncListBlobsOutput, Error> {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.sync.listBlobs") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
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
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/vnd.ipld.car",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: SyncListBlobsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
