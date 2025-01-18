//
//  GetSuggestionsSkeleton.swift
//
//
//  Created by Christopher Jr Riley on 2024-04-16.
//

import Foundation

extension ATProtoKit {

    /// Gets a skeleton of suggested actors.
    ///  
    /// - Note: According to the AT Protocol specifications: "Get a skeleton of suggested actors.
    /// Intended to be called and then hydrated through
    /// app.bsky.actor.getSuggestions."
    ///  
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    /// 
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getSuggestionsSkeleton`][github] lexicon.
    ///  
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getSuggestionsSkeleton.json
    ///  
    /// - Parameters:
    ///   - viewerDID: The decentralized identifier (DID) of the requesting account. Optional.
    ///   - limit: - limit: The number of items the list will hold. Optional. Defaults to `50`. Can
    ///   only be between `1` and `100`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    ///   - relativeToDID: The decentralized identifier (DID) of the user account to get
    ///   suggestions to. Optional.
    /// - Returns: An array of actors, with an optional cursor to expend the array, and a snowflake
    /// ID for recommendations. It can also include an optional value for the
    /// decentralized identifier (DID) of the user account related to the suggestions.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSuggestionsSkeleton(
        viewerDID: String? = nil,
        limit: Int? = 50,
        cursor: String? = nil,
        relativeToDID: String? = nil
    ) async throws -> AppBskyLexicon.Unspecced.GetSuggestionsSkeletonOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.serviceEndpoint,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getSuggestionsSkeleton") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let viewerDID {
            queryItems.append(("viewer", viewerDID))
        }

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        if let relativeToDID {
            queryItems.append(("relativeToDid", relativeToDID))
        }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Unspecced.GetSuggestionsSkeletonOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
