//
//  DescribeRepo.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-11.
//

import Foundation

extension ATProtoKit {
    /// Describes the repository.
    /// 
    /// - Parameter repositoryDID: The decentralized identifier (DID) or handle of the repository.
    /// - Returns: A `Result`, containing either a ``RepoDescribeRepoOutput`` if successful, ot an `Error` if not.
    public static func describeRepository(_ repositoryDID: String, pdsURL: String = "https://bsky.social") async throws -> Result<RepoDescribeRepoOutput, Error> {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/app.bsky.repo.describeRepo") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        var queryItems = [(String, String)]()

        queryItems.append(("repo", repositoryDID))

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request, decodeTo: RepoDescribeRepoOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
