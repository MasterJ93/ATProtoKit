//
//  GetListFeed.swift
//  
//
//  Created by Christopher Jr Riley on 2024-03-06.
//

import Foundation

extension ATProtoKit {

    /// Retireves recent posts and reposts from a given list feed.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a feed of recent posts from a
    /// list (posts and reposts from any actors on the list). Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getListFeed`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getListFeed.json
    ///
    /// - Parameters:
    ///   - uri: The URI of a list.
    ///   - limit: The number of suggested users to follow. Optional. Defaults to `50`.
    ///   Can only choose between `1` and `100`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    ///   - accessToken: The access token of the user. Optional.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://api.bsky.app`.
    /// - Returns: An array of posts in a feed, with an optional cursor to extend the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getListFeed(
        from uri: String,
        limit: Int? = 50,
        cursor: String? = nil,
        accessToken: String? = nil,
        pdsURL: String = "https://api.bsky.app"
    ) async throws -> AppBskyLexicon.Feed.GetListFeedOutput {
        guard pdsURL != "" else {
            throw ATRequestPrepareError.emptyPDSURL
        }

        guard let requestURL = URL(string: "\(pdsURL)/xrpc/app.bsky.feed.getListFeed") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("list", uri))

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
                authorizationValue: nil
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Feed.GetListFeedOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
