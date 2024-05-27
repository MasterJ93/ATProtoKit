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
    /// When `getPosts` is called, it will return a detailed view of each post, which is sometimes
    /// called "hydration."
    ///
    /// - Note: Current maximum length for `postURIs` is 25 items. This library will cap the
    /// `Array` at that size if it does go above the limit.
    ///
    /// - Note: According to the AT Protocol specifications: "Gets post views for a specified list
    /// of posts (by AT-URI). This is sometimes referred to as 'hydrating' a 'feed skeleton'."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getPosts`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getPosts.json
    ///
    /// - Parameter postURIs: An array of URIs of post records.
    /// - Returns: A `Result`, containing either a ``FeedGetPostsOutput``
    /// if successful, or an `Error` if not.
    public func getPosts(_ postURIs: [String]) async throws -> Result<FeedGetPostsOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getPosts") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        // Cap the array to 25 items.
        let cappedURIArray = postURIs.prefix(25)
        queryItems += cappedURIArray.map { ("uris", $0) }

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
                                                                  decodeTo: FeedGetPostsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
