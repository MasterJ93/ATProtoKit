//
//  GetReporterStats.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-20.
//

import Foundation

extension ATProtoAdmin {

    /// Retrieves statistics about reporters for a list of users.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get reporter stats for a list
    /// of users."
    /// 
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.getReporterStats`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/getReporterStats.json
    /// 
    /// - Parameter dids: An array of Decentralized Identifiers (DIDs) to extract the
    /// repository information. Limits to 100 items.
    /// - Returns: An array of reporter statistics.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getReporterStats(from dids: [String]) async throws -> ToolsOzoneLexicon.Moderation.GetReporterStatsOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.moderation.getReporterStats") else {
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

            let request = await APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ToolsOzoneLexicon.Moderation.GetReporterStatsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
