//
//  AdminSearchAccountsAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-05.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Lists accounts from a search query as an adminstrator.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to
    /// access this; if they attempt to do so, an error will occur.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get list of accounts that matches
    /// your search query."
    /// 
    /// - SeeAlso: This is based on the [`com.atproto.admin.searchAccounts`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/searchAccounts.json
    /// 
    /// - Parameters:
    ///   - email: The email addressed used as the search query. Optional.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    ///   - limit: The number of repositories in the array. Optional. Defaults to `50`. Can only
    ///   choose between `1` and `100`.
    /// - Returns: An array of accounts from a search query, with an optional cursor to extend
    /// the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func searchAccounts(
        by email: String? = nil,
        cursor: String? = nil,
        limit: Int? = 50
    ) async throws -> ComAtprotoLexicon.Admin.SearchAccountsOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.searchAccounts") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let email {
            queryItems.append(("email", email))
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
                decodeTo: ComAtprotoLexicon.Admin.SearchAccountsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
