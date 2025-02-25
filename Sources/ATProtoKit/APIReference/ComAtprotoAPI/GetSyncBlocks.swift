//
//  GetSyncBlocks.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-12.
//

import Foundation

extension ATProtoKit {

    /// Gets a repository's blocks based on the CID hashes.
    /// 
    /// This method returns a `Data` object, but is formatted as a .car format. It's your
    /// responsibility to handle this file.
    ///
    /// - Note: According to the AT Protocol specifications: "Get data blocks from a given repo,
    /// by CID. For example, intermediate MST nodes, or records. Does not require auth;
    /// implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.getBlocks`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/getBlocks.json
    ///
    ///
    /// - Parameters:
    ///   - repositoryDID: The decentralized identifier (DID) of the repository.
    ///   - repositoryCIDs: An array of CID hashes from the repository.
    /// - Returns: A .car file, containing CBOR-encoded data of the repository blocks.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSyncBlocks(
        from repositoryDID: String,
        by repositoryCIDs: [String]
    ) async throws -> Data {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.sync.getBlocks") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("did", repositoryDID))
        queryItems += repositoryCIDs.map { ("cids", $0) }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(
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
