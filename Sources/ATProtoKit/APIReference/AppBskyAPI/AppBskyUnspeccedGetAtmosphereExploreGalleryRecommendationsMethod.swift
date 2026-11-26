//
//  AppBskyUnspeccedGetAtmosphereExploreGalleryRecommendationsMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Gets a skeleton of recommended Atmosphere Explore Grain galleries.
    ///
    /// - Important: This is an unspecced method, and as such, this is highly volatile and may change or be
    /// removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a skeleton of recommended Atmosphere
    /// Explore Grain galleries. Intended to be called and hydrated by
    /// app.bsky.unspecced.getAtmosphereExploreTab."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereExploreGalleryRecommendations`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereExploreGalleryRecommendations.json
    ///
    /// - Parameters:
    ///   - viewer: The decentralized identifier (DID) of the requested user account. Optional.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `25`.
    ///   Can only choose between `1` and `100`.
    /// - Returns: An array of skeleton galleries, with a Snowflake ID for recommendation events.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getAtmosphereExploreGalleryRecommendations(
        viewer: String? = nil,
        limit: Int? = 25
    ) async throws -> AppBskyLexicon.Unspecced.GetAtmosphereExploreGalleryRecommendationsOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getAtmosphereExploreGalleryRecommendations") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let viewer {
            queryItems.append(("viewer", viewer))
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
                requiresAuthorization: true
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Unspecced.GetAtmosphereExploreGalleryRecommendationsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
