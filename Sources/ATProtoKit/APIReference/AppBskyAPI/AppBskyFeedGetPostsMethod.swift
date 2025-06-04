//
//  AppBskyFeedGetPostsMethod.swift
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
    /// - Parameter uris: An array of URIs of post records.
    /// - Returns: An array of hydrated posts.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getPosts(_ uris: [String]) async throws -> AppBskyLexicon.Feed.GetPostsOutput {
        do {
            let (authorizationValue, sessionURL) = try await prepareAuthorization(rquiresAuth: false)
            
            let queryURL = try await prepareRequest(sessionURL: sessionURL, endpoint: "/xrpc/app.bsky.feed.getPosts") { queryItems in
                queryItems += uris.prefix(25).map { ("uris", $0) }
            }

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: authorizationValue
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Feed.GetPostsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
