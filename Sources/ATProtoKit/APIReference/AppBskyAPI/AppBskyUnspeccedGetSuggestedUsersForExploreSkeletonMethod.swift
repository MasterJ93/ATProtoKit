//
//  AppBskyUnspeccedGetSuggestedUsersForExploreSkeletonMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Gets a skeleton version of suggested users for the Explore page.
    ///
    /// - Important: This is an unspecced method, and as such, this is highly volatile and may change or be
    /// removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a skeleton of suggested users for the
    /// Explore page. Intended to be called and hydrated by
    /// app.bsky.unspecced.getSuggestedUsersForExplore"
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getSuggestedUsersForExploreSkeleton`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getSuggestedUsersForExploreSkeleton.json
    ///
    /// - Parameters:
    ///   - viewer: The decentralized identifier (DID) of the requested user account. Optional.
    ///   - category: The category of users to get suggestions for. Optional.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `25`.
    ///   Can only choose between `1` and `50`.
    /// - Returns: An array of decentralized identifiers (DIDs) representing user accounts.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSuggestedUsersForExploreSkeleton(
        viewer: String? = nil,
        category: String? = nil,
        limit: Int? = 25
    ) async throws -> AppBskyLexicon.Unspecced.GetSuggestedUsersForExploreSkeletonOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getSuggestedUsersForExploreSkeleton") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let viewer {
            queryItems.append(("viewer", viewer))
        }

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
                decodeTo: AppBskyLexicon.Unspecced.GetSuggestedUsersForExploreSkeletonOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
