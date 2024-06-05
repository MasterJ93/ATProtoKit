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
    /// - Note: According to the AT Protocol specifications: "Get information about an account
    /// and repository, including the list of collections. Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.describeRepo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/describeRepo.json
    ///
    /// - Parameter repositoryDID: The decentralized identifier (DID) or handle of the repository.
    /// - Returns: A `Result`, containing either a
    /// ``ComAtprotoLexicon/Repository/DescribeRepositoryOutput``
    /// if successful, ot an `Error` if not.
    public func describeRepository(
        _ repositoryDID: String,
        pdsURL: String? = nil
    ) async throws -> Result<ComAtprotoLexicon.Repository.DescribeRepositoryOutput, Error> {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.describeRepo") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        queryItems.append(("repo", repositoryDID))

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: ComAtprotoLexicon.Repository.DescribeRepositoryOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
