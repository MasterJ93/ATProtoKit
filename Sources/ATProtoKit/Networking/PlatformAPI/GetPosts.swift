//
//  GetPosts.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-06.
//

import Foundation

extension ATProtoKit {
    /// Retrieves an array of posts.
    ///
    /// When `getPosts` is called, it will return a detailed view of each post, which is sometimes called "hydration."
    ///
    /// - Note: Current maximum length for `postURIs` is 25 items. This library will cap the `Array` at that size if it does go above the limit.
    ///
    /// - Parameter postURIs: An array of URIs of post records.
    /// - Returns: A `Result`, containing either a ``FeedGetPostsOutput`` if successful, or an `Error` if not.
    public func getPosts(_ postURIs: [String]) async throws -> Result<FeedGetPostsOutput, Error>{
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getPosts") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        var queryItems = [(String, String)]()

        // Cap the array to 25 items.
        let cappedURIArray = postURIs.prefix(25)
        queryItems += cappedURIArray.map { ("uris", $0) }

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
            let response = try await APIClientService.sendRequest(request, decodeTo: FeedGetPostsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
