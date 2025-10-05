//
//  AppBskyUnspeccedGetOnboardingSuggestedStarterPacksMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-10-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Retrieves a list of suggested starterpacks for onboarding.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of suggested starterpacks
    /// for onboarding."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getOnboardingSuggestedStarterPacks`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getOnboardingSuggestedStarterPacks.json
    ///
    /// - Parameter limit: The number of items that can be in the list. Optional. Defaults to `10`.
    /// - Returns: An array of starter packs.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getOnboardingSuggestedStarterPacks(limit: Int? = 10) async throws -> AppBskyLexicon.Unspecced.GetOnboardingSuggestedStarterPacksOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getOnboardingSuggestedStarterPacks") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

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
                decodeTo: AppBskyLexicon.Unspecced.GetOnboardingSuggestedStarterPacksOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
