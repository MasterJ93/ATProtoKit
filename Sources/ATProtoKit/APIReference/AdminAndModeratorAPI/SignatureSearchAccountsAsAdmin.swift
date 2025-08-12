//
//  SignatureSearchAccountsAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-10-24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Searches user accounts that match one or more threat signature values.
    ///
    /// - Note: According to the AT Protocol specifications: "Search for accounts that match one or
    /// more threat signature values."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.signature.searchAccounts`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/signature/searchAccounts.json
    /// 
    /// - Parameters:
    ///   - values: An array of values.
    ///   - limit: The number of repositories in the array. Optional. Defaults to `50`. Can only
    ///   choose between `1` and `100`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of accounts, with an optional cursor to extend the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func searchAccounts(
        matching values: [String],
        cursor: String? = nil,
        limit: Int? = 50
    ) async throws -> ToolsOzoneLexicon.Signature.SearchAccountsOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.signature.searchAccounts") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems += values.map { ("values", $0) }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

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
                decodeTo: ToolsOzoneLexicon.Signature.SearchAccountsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
