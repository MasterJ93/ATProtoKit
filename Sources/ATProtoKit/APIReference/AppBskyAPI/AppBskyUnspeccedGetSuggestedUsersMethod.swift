//
//  AppBskyUnspeccedGetSuggestedUsersMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-14.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Gets an array of suggested user accounts.
    ///
    /// - Important: This is an unspecced method, and as such, this is highly volatile and may change or be
    /// removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Category of users to get suggestions for."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getSuggestedUsers`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getSuggestedUsers.json
    ///
    /// - Parameters:
    ///   - category: The category of users to get suggestions for.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `25`.
    /// - Returns: An array of user accounts based on the category.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSuggestedUsers(
        category: String? = nil,
        limit: Int? = 25
    ) async throws -> AppBskyLexicon.Unspecced.GetSuggestedUsersOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getSuggestedUsers") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let category {
            queryItems.append(("category", category))
        }

        if let limit {
            let finalLimit = max(1, min(limit, 50))
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
                decodeTo: AppBskyLexicon.Unspecced.GetSuggestedUsersOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
