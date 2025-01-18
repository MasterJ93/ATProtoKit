//
//  GetTimeline.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-06.
//

import Foundation

extension ATProtoKit {

    /// Gets the user account's timeline.
    /// 
    /// - Note: As of now, the `algorithm` value only supports a reverse-chonological order, and
    /// so the use cases of this are limited. It's best to use methods such as
    /// ``getFeedGenerators(by:)`` and combine them with this method if you want to tweak how
    /// the timeline works.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a view of the requesting
    /// account's home timeline. This is expected to be some form of reverse-chronological feed."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getTimeline`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getTimeline.json
    ///
    /// - Parameters:
    ///   - algorithm: The selected "algorithm" to use. Defaults to a reverse-chronological order
    ///   if no value is inserted.
    ///   - limit: The number of items the list will hold. Optional. Defaults to `50`. Can only be
    ///   between `1` and `100`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of post records, with an optional cursor to expend the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getTimeline(
        using algorithm: String? = nil,
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> AppBskyLexicon.Feed.GetTimelineOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.serviceEndpoint,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getTimeline") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()
        if let algorithm {
            queryItems.append(("algorithm", algorithm))
        }

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

            let request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Feed.GetTimelineOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
