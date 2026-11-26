//
//  AppBskyUnspeccedGetAtmosphereExploreTabMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Gets Atmosphere Explore content.
    ///
    /// - Important: This is an unspecced method, and as such, this is highly volatile and may change or be
    /// removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get Atmosphere Explore content. Articles
    /// and photo galleries are recommended when their algorithmic recommendations are enabled for
    /// the request, and curated otherwise; other sections are curated. Curated content is selected
    /// using the x-atproto-bsky-geo-country, x-atproto-bsky-geo-region, and x-atproto-bsky-topics
    /// request headers. Authentication is optional; authenticated requests include viewer-specific
    /// profile state."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereExploreTab`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereExploreTab.json
    ///
    /// - Parameters:
    ///   - languages: An array of preferred languages for the recommendations. Optional.
    /// - Returns: Articles, publications, photo galleries, livestreams, and app cards for the Explore tab,
    /// with an optional announcement banner.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getAtmosphereExploreTab(
        languages: [String]? = nil
    ) async throws -> AppBskyLexicon.Unspecced.GetAtmosphereExploreTabOutput {
        let session = try await self.getUserSession()
        let requiresAuthorization = session != nil

        let sessionURL = session?.serviceEndpoint.absoluteString ?? self.pdsURL
        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getAtmosphereExploreTab") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

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
                decodeTo: AppBskyLexicon.Unspecced.GetAtmosphereExploreTabOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
