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
    /// - Returns: A `Result`, containing either an
    /// ``AppBskyLexicon/Unspecced/GetSuggestionsSkeletonOutput``
    /// if successful, or an `Error` if not.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSuggestionsSkeleton(
        viewerDID: String?,
        limit: Int? = 50
    ) async throws -> Result<AppBskyLexicon.Unspecced.GetSuggestionsSkeletonOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getSuggestionsSkeleton") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        if let viewerDID {
            queryItems.append(("viewer", viewerDID))
        }

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: AppBskyLexicon.Unspecced.GetSuggestionsSkeletonOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
