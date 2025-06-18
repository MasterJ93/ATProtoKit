//
//  AppBskyUnspeccedGetSuggestedFeedsSkeletonMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-14.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Gets an array of URIs for suggested feeds.
    ///
    /// - Important: This is an unspecced method, and as such, this is highly volatile and may change or be
    /// removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a skeleton of suggested feeds.
    /// Intended to be called and hydrated by app.bsky.unspecced.getSuggestedFeeds."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getSuggestedFeedsSkeleton`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getSuggestedFeedsSkeleton.json
    ///
    /// - Parameters:
    ///   - viewer: The decentralized identifier (DID) of the requested user account. Optional.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `10`.
    /// - Returns: An array of feed generator's URIs.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSuggestedFeedsSkeleton(
        viewer: String? = nil,
        limit: Int? = 10
    ) async throws -> AppBskyLexicon.Unspecced.GetSuggestedFeedsSkeletonOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getSuggestedFeedsSkeleton") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let viewer {
            queryItems.append(("viewer", viewer))
        }

        if let limit {
            let finalLimit = max(1, min(limit, 25))
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
                decodeTo: AppBskyLexicon.Unspecced.GetSuggestedFeedsSkeletonOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
