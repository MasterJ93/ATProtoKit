//
//  GetRepositoryStatus.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation

extension ATProtoKit {

    /// Retrieves the status for a repository in the Personal Data Server (PDS).
    /// 
    /// - Note: According to the AT Protocol specifications: "Get the hosting status for a
    /// repository, on this server. Expected to be implemented by PDS and Relay."
    /// 
    /// - SeeAlso: This is based on the [`com.atproto.sync.getRepoStatus`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/getRepoStatus.json
    /// 
    /// - Parameter actorDID: The decentralized identifier (DID) of the user account.
    /// - Returns: A `Result`, containing either a
    /// ``ComAtprotoLexicon/Sync/GetRepositoryStatusOutput``
    ///  if successful, or an `Error` if not.
    ///
    ///  - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getRepositoryStatus(from actorDID: String) async throws -> Result<ComAtprotoLexicon.Sync.GetRepositoryStatusOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.sync.getRepoStatus") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        queryItems.append(("did", actorDID))

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
                                                                  decodeTo: ComAtprotoLexicon.Sync.GetRepositoryStatusOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
