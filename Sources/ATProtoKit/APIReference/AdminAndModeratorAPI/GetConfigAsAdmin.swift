//
//  GetConfigAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-05.
//

import Foundation

extension ATProtoAdmin {

    /// Retrieves details about the Ozone server's configuration.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get details about ozone's
    /// server configuration."
    /// 
    /// - SeeAlso: This is based on the [`tools.ozone.server.getConfig`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/server/getConfig.json
    /// 
    /// - Returns:The details about the Ozone server's configuration.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getConfiguration() async throws -> ToolsOzoneLexicon.Server.GetConfigurationOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.server.getConfig") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let queryItems = [(String, String)]()

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
                decodeTo: ToolsOzoneLexicon.Server.GetConfigurationOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
