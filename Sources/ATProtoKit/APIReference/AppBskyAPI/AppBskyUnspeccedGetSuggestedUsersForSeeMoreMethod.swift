//
//  AppBskyUnspeccedGetSuggestedUsersForSeeMoreMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Gets an array of suggested user accounts for the See More page.
    ///
    /// - Important: This is an unspecced method, and as such, this is highly volatile and may change or be
    /// removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of suggested users for the See
    /// More page"
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getSuggestedUsersForSeeMore`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getSuggestedUsersForSeeMore.json
    ///
    /// - Parameters:
    ///   - category: The category of users to get suggestions for. Optional.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `25`.
    ///   Can only choose between `1` and `50`.
    /// - Returns: An array of user accounts.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSuggestedUsersForSeeMore(
        category: String? = nil,
        limit: Int? = 25
    ) async throws -> AppBskyLexicon.Unspecced.GetSuggestedUsersForSeeMoreOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getSuggestedUsersForSeeMore") else {
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
                requiresAuthorization: true
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Unspecced.GetSuggestedUsersForSeeMoreOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
