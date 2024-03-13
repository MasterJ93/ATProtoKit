//
//  GetLatestCommit.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-12.
//

import Foundation

extension ATProtoKit {
    /// Gets a repository's latest commit CID.
    ///
    public static func getLatestCommit(from repositoryDID: String, pdsURL: String = "https://bsky.social") async throws -> Result<SyncGetBlocksOutput, Error> {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.sync.getLatestCommit") else {
            print("Failure")
            return .failure(URIError.invalidFormat)
        }

        let queryItems = [("did", repositoryDID)]

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/vnd.ipld.car",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request, decodeTo: SyncGetBlocksOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
