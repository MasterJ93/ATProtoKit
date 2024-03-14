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
    ///  
    /// - Parameters:
    ///   - searchQuery: The string being searched against. Lucene query syntax recommended.
    ///   - limit: The number of suggested users to follow. Optional. Defaults to `25`. Can only choose between `1` and `100`.
    ///   - cursor: The mark used to indicate the starting point for the next set of results. Optional.
    /// - Returns: A `Result`, containing either an ``FeedSearchPostsOutput`` if succesful, or an `Error` if it's not.
    public func searchPosts(with searchQuery: String, limit: Int? = 25, cursor: String? = nil) async throws -> Result<FeedSearchPostsOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.searchPosts") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
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

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, decodeTo: FeedSearchPostsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }

    }
}
