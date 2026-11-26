//
//  AppBskyUnspeccedGetAtmosphereAppsMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Gets curated Atmosphere apps.
    ///
    /// - Important: This is an unspecced method, and as such, this is highly volatile and may change or be
    /// removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get curated Atmosphere apps. Authentication
    /// is optional; authenticated requests include viewer-specific profile state and known followers."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereApps`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereApps.json
    ///
    /// - Parameters:
    ///   - category: The category of apps to return. Optional.
    /// - Returns: An array of app cards.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getAtmosphereApps(
        category: String? = nil
    ) async throws -> AppBskyLexicon.Unspecced.GetAtmosphereAppsOutput {
        let session = try await self.getUserSession()
        let requiresAuthorization = session != nil

        let sessionURL = session?.serviceEndpoint.absoluteString ?? self.pdsURL
        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getAtmosphereApps") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let category {
            queryItems.append(("category", category))
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
                decodeTo: AppBskyLexicon.Unspecced.GetAtmosphereAppsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
