//
//  GetRepositoriesAsAdmin.swift.swift
//
//  Created by Christopher Jr Riley on 2024-10-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Gets an array of repositories as a moderator.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get details about some repositories."
    /// 
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.getRepos`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/getRepos.json
    /// 
    /// - Parameter dids: An array of decentralized identifiers (DIDs) to extract the
    /// repository information. Limits to 100 items.
    /// - Returns: An aray of repositories based on the decentralized identifiers (DIDs) given.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getRepositories(from dids: [String]) async throws -> ToolsOzoneLexicon.Moderation.GetRepositoriesOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.moderation.getRepos") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        let cappedDIDArray = dids.prefix(100)
        queryItems += cappedDIDArray.map { ("dids", $0) }

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
                decodeTo: ToolsOzoneLexicon.Moderation.GetRepositoriesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
