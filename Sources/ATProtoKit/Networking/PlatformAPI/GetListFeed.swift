//
//  GetListFeed.swift
//  
//
//  Created by Christopher Jr Riley on 2024-03-06.
//

import Foundation

extension ATProtoKit {
    /// Retireves recent posts and reposts from a given feed.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get a feed of recent posts from a list (posts and reposts from any actors on the list). Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getListFeed`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getListFeed.json
    ///
    /// - Parameters:
    ///   - listURI: The URI of the feed.
    ///   - limit: limit: The number of suggested users to follow. Optional. Defaults to `50`. Can only choose between `1` and `100`.
    ///   - cursor: The mark used to indicate the starting point for the next set of results. Optional.
    ///   - accessToken: The access token of the user. Optional.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: A `Result`, containing either an ``FeedGetListFeedOutput`` if succesful, or an `Error` if it's not.
    public func getListFeed(from listURI: String, limit: Int? = 50, cursor: String? = nil,
                                   accessToken: String? = nil,
                                   pdsURL: String? = nil) async throws -> Result<FeedGetListFeedOutput, Error> {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getListFeed") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        queryItems.append(("list", listURI))

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
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: FeedGetListFeedOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
