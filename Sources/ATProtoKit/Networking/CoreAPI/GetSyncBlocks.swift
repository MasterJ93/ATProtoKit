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
    /// This method returns a `Data` object, but is formatted as a .car format. It's your responsibility to handle this file.
    /// - Parameters:
    ///   - repositoryDID: The decentralized identifier (DID) of the repository.
    ///   - repositoryCIDHashes: An array of CID hashes from the repository.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: A `Result`, containing either
    public static func getSyncBlocks(from repositoryDID: String, by repositoryCIDHashes: [String], pdsURL: String = "https://bsky.social") async throws -> Result<Data, Error> {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.sync.getBlocks") else {
            print("Failure")
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()
//        let queryItems = [
//            ("did", blobQuery.accountDID),
//            ("cid", blobQuery.cidHash)
//        ]

        queryItems.append(("did", repositoryDID))
        queryItems += repositoryCIDHashes.map { ("cids", $0) }

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
