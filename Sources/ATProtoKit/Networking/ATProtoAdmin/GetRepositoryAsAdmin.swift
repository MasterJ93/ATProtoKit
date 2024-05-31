//
//  GetRepoAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-01.
//

import Foundation

extension ATProtoAdmin {

    /// Get details about a repository as an administrator.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to
    /// access this; if they attempt to do so, an error will occur.
    ///
    /// - Note: According to the AT Protocol specifications: "Get details about a repository."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.getRepo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/getRepo.json
    ///
    /// - Parameter repositoryDID: The decentralized identifier (DID) of the repository.
    /// - Returns: A `Result`, containing either an ``ToolsOzoneLexicon/Moderation/RepositoryViewDefinition``
    /// if successful, or an `Error` if not.
    public func getRepository(_ repositoryDID: String) async throws -> Result<ToolsOzoneLexicon.Moderation.RepositoryViewDetailDefinition, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.moderation.getRepo") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let queryItems = [("did", repositoryDID)]

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
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: ToolsOzoneLexicon.Moderation.RepositoryViewDetailDefinition.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
