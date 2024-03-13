//
//  GetRepo.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-13.
//

import Foundation

extension ATProtoKit {
    /// Gets a repository in a .car format.
    /// 
    /// - Parameters:
    ///   - repositoryDID: The decentralized identifier (DID) or handle of the repository.
    ///   - since: The repository's revision for diff creation. Optional.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    /// - Returns: A `Result`, containing either a `Data` object if successful, or an `Error` if not.
    public static func getRepo(_ repositoryDID: String, since: String? = nil, pdsURL: String = "https://bsky.social") async throws -> Result<Data, Error> {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.sync.getRepo") else {
            return .failure(URIError.invalidFormat)
        }

        var queryItems = [(String, String)]()

        queryItems.append(("did", repositoryDID))

        if let since {
            queryItems.append(("since", since))
        }

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
            let response = try await APIClientService.sendRequest(request)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
