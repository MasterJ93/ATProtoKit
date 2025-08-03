//
//  AppBskyUnspeccedGetTrendingTopicsMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-30.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Retrieves the list of topics that are currently trending in Bluesky.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may change
    /// or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "DID of the account making the
    /// request (not included for public/unauthenticated queries). Used to boost followed accounts
    /// in ranking."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getTrendingTopics`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getTrendingTopics.json
    ///
    /// - Parameters:
    ///   - viewerDID: The decentralized identifier (DID) of the requesting account. Optional.
    ///   - limit: - limit: The number of items the list will hold. Optional. Defaults to `10`. Can
    ///   only be between `1` and `25`.
    /// - Returns: An array of the trending topics, as well as an array of suggested feeds
    /// based on the user account's activity.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getTrendingTopics(
        viewerDID: String? = nil,
        limit: Int? = 10
    ) async throws -> AppBskyLexicon.Unspecced.GetTrendingTopicsOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getTrendingTopics") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let viewerDID {
            queryItems.append(("viewer", viewerDID))
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
                decodeTo: AppBskyLexicon.Unspecced.GetTrendingTopicsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
