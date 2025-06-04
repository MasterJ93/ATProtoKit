//
//  AppBskyFeedGetAuthorFeedMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-04.
//

import Foundation

extension ATProtoKit {

    /// Retrieves the user account's posts and reposts.
    ///
    /// - Note: Despite the fact that the documentation in the AT Protocol specifications
    /// say that this API call doesn't require auth, testing shows that this is not true. It's
    /// unclear whether this is intentional (and therefore, the documentation is outdated) or
    /// unintentional (in this case, the underlying implementation is outdated). For now, this
    /// method will act as if auth is required until Bluesky clarifies their position.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a view of an actor's
    /// 'author feed' (post and reposts by the author). Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getAuthorFeed`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getAuthorFeed.json
    ///
    /// - Parameters:
    ///   - actorDID: The decentralized identifier (DID) of the user account.
    ///   - limit: The number of items the list will hold. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    ///   - postFilter: The supported post and/or repost combinations in responses.  Optional.
    ///   Defaults to `.postsWithReplies`.
    ///   - shouldIncludePins: Indicates whether the output includes pinned posts. Optional.
    /// - Returns: An array of feeds created by the specified user account, with an optional cursor
    /// to extend the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getAuthorFeed(
        by actorDID: String,
        limit: Int? = 50,
        cursor: String? = nil,
        postFilter: AppBskyLexicon.Feed.GetAuthorFeed.Filter? = .postsWithReplies,
        shouldIncludePins: Bool? = false
    ) async throws -> AppBskyLexicon.Feed.GetAuthorFeedOutput {
        do {
            let (authorizationValue, sessionURL) = try await prepareAuthorization(rquiresAuth: false)
            
            let queryURL = try await prepareRequest(sessionURL: sessionURL, endpoint: "/xrpc/app.bsky.feed.getAuthorFeed") { queryItems in
                addQueryItem("actor", value: actorDID, to: &queryItems)
                addLimit(limit, max: 100, to: &queryItems)
                addCursor(cursor, to: &queryItems)
                addQueryItem("filter", value: postFilter?.rawValue, to: &queryItems)
                addQueryItem("includePins", value: shouldIncludePins, to: &queryItems)
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
                decodeTo: AppBskyLexicon.Feed.GetAuthorFeedOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
