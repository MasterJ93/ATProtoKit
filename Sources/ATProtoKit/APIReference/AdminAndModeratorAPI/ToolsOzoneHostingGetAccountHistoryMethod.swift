//
//  ToolsOzoneHostingGetAccountHistoryMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-17.
//

import Foundation

extension ATProtoAdmin {

    /// Gets the account history of a given user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Get account history, e.g. log of updated
    /// email addresses or other identity information."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.hosting.getAccountHistory`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/hosting/getAccountHistory.json
    ///
    /// - Parameters:
    ///   - did: The decentralized identifier (DID) of the user account.
    ///   - event: An array of event details to look for. Optional.
    ///   - cursor: The mark used to indicate the starting point for the next set of results. Optional.
    ///   - limit: The number of repositories in the array. Optional. Defaults to `50`. Can only
    ///   choose between `1` and `100`.
    /// - Returns: An array of events connected to the user account, with an optional cursor to extend
    /// the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getAccountHistory(
        for did: String,
        events: [ToolsOzoneLexicon.Hosting.GetAccountHistory.Events]? = nil,
        cursor: String? = nil,
        limit: Int? = 50
    ) async throws -> ToolsOzoneLexicon.Hosting.GetAccountHistoryOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.hosting.getAccountHistory") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("did", did))

        if let events {
            queryItems += events.map { ("events", $0.rawValue) }
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

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
                decodeTo: ToolsOzoneLexicon.Hosting.GetAccountHistoryOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
