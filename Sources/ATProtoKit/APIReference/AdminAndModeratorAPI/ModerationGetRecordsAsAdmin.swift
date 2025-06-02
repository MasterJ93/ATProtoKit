//
//  ModerationGetRecordsAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-10-06.
//

import Foundation

extension ATProtoAdmin {

    /// Gets records as a moderator.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get details about some records."
    /// 
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.getRecords`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/getRecords.json
    /// 
    /// - Parameter recordURIs: An array of record URIs.
    /// - Returns: An array of records.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getRecords(by recordURIs: [String]) async throws -> ToolsOzoneLexicon.Moderation.GetRecordsOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.moderation.getRecords") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems += recordURIs.prefix(100).map { ("reportTypes", $0) }

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
                decodeTo: ToolsOzoneLexicon.Moderation.GetRecordsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
