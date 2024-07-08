//
//  GetSuggestedFeeds.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-06.
//

import Foundation

extension ATProtoKit {

    /// Gets a list of feed generators suggested for the user account.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get a list of suggested feeds
    /// (feed generators) for the requesting account."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getSuggestedFeeds`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getSuggestedFeeds.json
    ///
    /// - Parameters:
    ///   - limit: The number of items the list will hold. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   result. Optional.
    /// - Returns: An array of feed generators, with an optional cursor to extend the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSuggestedFeeds(
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> AppBskyLexicon.Feed.GetSuggestedFeedsOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getSuggestedFeeds") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
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
                                                                  decodeTo: AppBskyLexicon.Feed.GetSuggestedFeedsOutput.self)

            return response
        } catch {
            throw error
        }
    }
}
