//
//  AppBskyUnspeccedGetAtmosphereRecommendedActivityMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Gets recommended Atmosphere activity.
    ///
    /// - Important: This is an unspecced method, and as such, this is highly volatile and may change or be
    /// removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get recommended Standard.site articles
    /// and Grain galleries for Atmosphere Activity in recommendation order. Authentication is
    /// optional. Unavailable items are omitted, so the response may contain fewer than the
    /// requested limit."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereRecommendedActivity`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereRecommendedActivity.json
    ///
    /// - Parameters:
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `25`.
    ///   Can only choose between `1` and `100`.
    ///   - languages: An array of preferred languages for the recommendations. Optional.
    /// - Returns: An array of recommended articles and galleries, with a Snowflake ID for
    /// recommendation events.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getAtmosphereRecommendedActivity(
        limit: Int? = 25,
        languages: [String]? = nil
    ) async throws -> AppBskyLexicon.Unspecced.GetAtmosphereRecommendedActivityOutput {
        let session = try await self.getUserSession()
        let requiresAuthorization = session != nil

        let sessionURL = session?.serviceEndpoint.absoluteString ?? self.pdsURL
        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getAtmosphereRecommendedActivity") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let languages {
            queryItems += languages.map { ("langs", $0) }
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
                requiresAuthorization: requiresAuthorization
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Unspecced.GetAtmosphereRecommendedActivityOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
