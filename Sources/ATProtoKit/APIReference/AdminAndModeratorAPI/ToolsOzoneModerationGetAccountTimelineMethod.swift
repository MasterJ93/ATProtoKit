//
//  ToolsOzoneModerationGetAccountTimelineMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-09-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Retrieves the timeline of all available events for an account, including moderation events, account
    /// history, and decentralized identifier (DID) history.
    ///
    /// - Note: According to the AT Protocol specifications: "Get timeline of all available events of
    /// an account. This includes moderation events, account history and did history."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.getAccountTimeline`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/getAccountTimeline.json
    ///
    /// - Parameter did: The decentralized identifier (DID) of the account to retrieve the timeline from.
    /// - Returns: An array of items in the account's timeline.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getAccountTimeline(for did: String) async throws -> ToolsOzoneLexicon.Moderation.GetAccountTimelineOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.moderation.getAccountTimeline") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("did", did))

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
                decodeTo: ToolsOzoneLexicon.Moderation.GetAccountTimelineOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
