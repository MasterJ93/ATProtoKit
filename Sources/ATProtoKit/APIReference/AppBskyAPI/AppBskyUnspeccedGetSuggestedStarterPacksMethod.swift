//
//  AppBskyUnspeccedGetSuggestedStarterPacksMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-14.
//

import Foundation

extension ATProtoKit {

    /// Gets an array of suggested starter packs.
    ///
    /// - Important: This is an unspecced method, and as such, this is highly volatile and may change or be
    /// removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of suggested starterpacks."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getSuggestedStarterPacks`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getSuggestedStarterPacks.json
    ///
    /// - Parameter limit: The number of items that can be in the list. Optional. Defaults to `10`.
    /// - Returns: An array of starter packs.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSuggestedStarterPacks(limit: Int? = 10) async throws -> AppBskyLexicon.Unspecced.GetSuggestedStarterPacksOutput {
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

        if let limit {
            let finalLimit = max(1, min(limit, 25))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = await APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Unspecced.GetSuggestedStarterPacksOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
