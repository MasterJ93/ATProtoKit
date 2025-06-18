//
//  AppBskyActorGetSuggestionsMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Gets a list of suggested users.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get a list of suggested actors.
    /// Expected use is discovery of accounts to follow during new account onboarding."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.getSuggestions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getSuggestions.json
    ///
    /// - Parameters:
    ///   - limit: The number of suggested users to follow. Optional. Defaults to 50.
    ///   Can only choose between 1 and 100.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of actors, with an optional cursor to extend the array, and an optional
    /// snowflake ID for recommendations.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSuggestions(
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> AppBskyLexicon.Actor.GetSuggestionsOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.actor.getSuggestions") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        // Make sure limit is between 1 and 100.
        let finalLimit = max(1, min(limit ?? 50, 100))
        var queryItems = [("limit", "\(finalLimit)")]

        if let cursor {
            queryItems.append(("cursor", cursor))
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
                acceptValue: nil,
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Actor.GetSuggestionsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
