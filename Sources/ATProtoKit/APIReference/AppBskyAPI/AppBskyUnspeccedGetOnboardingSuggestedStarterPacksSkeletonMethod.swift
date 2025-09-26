//
//  AppBskyUnspeccedGetOnboardingSuggestedStarterPacksSkeletonMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-10-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Retrieves the skeleton of suggested starterpacks for onboarding, intended to be called and hydrated
    /// by `app.bsky.unspecced.getOnboardingSuggestedStarterPacks`.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a skeleton of suggested starterpacks
    /// for onboarding. Intended to be called and hydrated
    /// by app.bsky.unspecced.getOnboardingSuggestedStarterPacks"
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getOnboardingSuggestedStarterPacksSkeleton`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getOnboardingSuggestedStarterPacksSkeleton.json
    ///
    /// - Parameters:
    ///   - viewer: The requesting user account’s decentralized identifier (DID).
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `10`.
    /// - Returns: An array of starter packs.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getOnboardingSuggestedStarterPacksSkeleton(
        viewer: String? = nil,
        limit: Int? = 10
    ) async throws -> AppBskyLexicon.Unspecced.GetOnboardingSuggestedStarterPacksSkeletonOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getOnboardingSuggestedStarterPacksSkeleton") else {
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
                decodeTo: AppBskyLexicon.Unspecced.GetOnboardingSuggestedStarterPacksSkeletonOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
