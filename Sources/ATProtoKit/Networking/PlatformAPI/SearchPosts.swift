//
//  SearchPosts.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-06.
//

import Foundation

extension ATProtoKit {
    /// Retrieves the results of a search query.
    /// 
    /// - Note: According to the AT Protocol specifications: "Find posts matching search criteria, returning views of those posts."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.searchPosts`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/searchPosts.json
    ///
    /// - Parameters:
    ///   - searchQuery: The string being searched against. Lucene query syntax recommended.
    ///   - limit: The number of suggested users to follow. Optional. Defaults to `25`. Can only choose between `1` and `100`.
    ///   - cursor: The mark used to indicate the starting point for the next set of results. Optional.
    /// - Returns: A `Result`, containing either an ``FeedSearchPostsOutput`` if succesful, or an `Error` if it's not.
    public func searchPosts(with searchQuery: String, limit: Int? = 25, cursor: String? = nil) async throws -> Result<FeedSearchPostsOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.searchPosts") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        queryItems.append(("q", searchQuery))

        if let limit {
            let finalLimit = min(1, max(limit, 100))
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
                                                                  decodeTo: FeedSearchPostsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }

    }
}
