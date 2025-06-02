//
//  ComAtprotoSyncGetBlobMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-10.
//

import Foundation

extension ATProtoKit {

    /// Retrieves a blob from a given record.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get a blob associated with a given
    /// account. Returns the full blob as originally uploaded. Does not require auth; implemented
    /// by PDS."
    /// 
    /// - SeeAlso: This is based on the [`com.atproto.sync.getBlob`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/getBlob.json
    ///
    /// - Parameters:
    ///   - accountDID: The decentralized identifier (DID) of the account.
    ///   - cid: The CID hash of the blob.
    /// - Returns: The data blob owned by the user account.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getBlob(
        from accountDID: String,
        cid: String
    ) async throws -> Data {
        guard let requestURL = URL(string: "https://bsky.network/xrpc/com.atproto.sync.getBlob") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let queryItems = [
            ("did", accountDID),
            ("cid", cid)
        ]

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "'*/*'",
                contentTypeValue: nil,
                authorizationValue: nil
            )
            let response = try await apiClientService.sendRequest(request)

            return response
        } catch {
            throw error
        }
    }
}
