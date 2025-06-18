//
//  AppBskyUnspeccedGetSuggestedUsersSkeletonMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-14.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Gets a skeleton version of suggested users.
    ///
    /// - Important: This is an unspecced method, and as such, this is highly volatile and may change or be
    /// removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a skeleton of suggested users. Intended to
    /// be called and hydrated by app.bsky.unspecced.getSuggestedUsers."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getSuggestedUsersSkeleton`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getSuggestedUsersSkeleton.json
    ///
    /// - Parameters:
    ///   - viewer: The decentralized identifier (DID) of the requested user account. Optional.
    ///   - category: The category of users to get suggestions for.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `25`.
    public func getSuggestedUsersSkeleton(
        viewer: String? = nil,
        category: String? = nil,
        limit: Int? = 25
    ) async throws -> AppBskyLexicon.Unspecced.GetSuggestedUsersSkeletonOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getSuggestedUsersSkeleton") else {
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
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Unspecced.GetSuggestedUsersSkeletonOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
