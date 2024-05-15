//
//  GetFeed.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-04.
//

import Foundation

extension ATProtoKit {

    /// Views a given feed generator.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get a hydrated feed from an actor's
    /// selected feed generator. Implemented by App View."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getFeed`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getFeed.json
    ///
    /// - Parameters:
    ///   - feedURI: The URI of the feed generator.
    ///   - limit: The number of items the list will hold. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   result. Optional.
    /// - Returns: A `Result`, containing either a ``FeedGetFeedOutput``
    /// if successful, or an `Error` if not.
    public func getFeed(_ feedURI: String, limit: Int? = 50, cursor: String? = nil) async throws -> Result<FeedGetFeedOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getFeed") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        queryItems.append(("feed", feedURI))

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
                                                                  decodeTo: FeedGetFeedOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
