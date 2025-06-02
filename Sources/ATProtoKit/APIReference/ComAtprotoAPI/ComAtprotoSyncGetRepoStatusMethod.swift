//
//  ComAtprotoSyncGetRepoStatusMethod.swift
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
    /// - Returns: The status of the repository, which includes its decentralized identifier (DID),
    /// active status, and an optional revision number.
    ///
    ///  - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getRepositoryStatus(from actorDID: String) async throws -> ComAtprotoLexicon.Sync.GetRepositoryStatusOutput {
        guard let _ = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
//        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "https://bsky.network/xrpc/com.atproto.sync.getRepoStatus") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("did", actorDID))

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Sync.GetRepositoryStatusOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
