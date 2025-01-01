//
//  GetRepositoriesAsAdmin.swift.swift
//
//  Created by Christopher Jr Riley on 2024-10-19.
//

import Foundation

extension ATProtoAdmin {

    /// Gets an array of repositories as a moderator.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get details about some repositories."
    /// 
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.getRepos`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/getRepos.json
    /// 
    /// - Parameter dids: An array of Decentralized Identifiers (DIDs) to extract the
    /// repository information. Limits to 100 items.
    /// - Returns: An aray of repositories based on the decentralized identifiers (DIDs) given.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getRepositories(from dids: [String]) async throws -> ToolsOzoneLexicon.Moderation.GetRepositoriesOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.moderation.getRepos") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        let cappedDIDArray = dids.prefix(100)
        queryItems += cappedDIDArray.map { ("dids", $0) }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ToolsOzoneLexicon.Moderation.GetRepositoriesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
