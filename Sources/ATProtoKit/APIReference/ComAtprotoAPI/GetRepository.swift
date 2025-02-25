//
//  GetRepository.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-13.
//

import Foundation

extension ATProtoKit {

    /// Gets a repository in a .car format.
    /// 
    /// - Note: According to the AT Protocol specifications: "Download a repository export as
    /// CAR file. Optionally only a 'diff' since a previous revision. Does not require auth;
    /// implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.getRepo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/getRepo.json
    ///
    /// - Parameters:
    ///   - did: The decentralized identifier (DID) or handle of the repository.
    ///   - sinceRevision: The revision of the repository to list blobs starting from. Optional.
    /// - Returns: A .car file, containing CBOR-encoded data of the full repository.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getRepository(
        by did: String,
        sinceRevision: String? = nil
    ) async throws -> Data {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.sync.getRepo") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("did", did))

        if let sinceRevision {
            queryItems.append(("since", sinceRevision))
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
