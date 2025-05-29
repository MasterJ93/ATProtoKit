//
//  ViewTrendingFeed.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-26.
//

import Foundation

extension ATProtoBluesky {

    /// Views the feed generator of the trending topic in Bluesky.
    ///
    /// - Important: This deals with trending topics, which is under the
    /// `app.bsky.unspecced.*` Namespaced Identifier (NSID). Lexicons under this can change at any time
    /// without warning. It may also be removed at any time without warning.. ATProtoKit will try to keep up
    /// with those changes, but this is not a guarantee.
    ///
    /// Before calling this method, be sure to use the methods provided to get the link of the
    /// trending feed. The method will then parse the link into an AT URI to find the feed for viewing.
    ///
    /// ```swift
    /// do {
    ///     let atProtoKit = await ATProtoKit(sessionConfiguration: config)
    ///     let atProtoBluesky = ATProtoBluesky(atProtoKitInstance: atProtoKit)
    ///
    ///     // Get the link of the trending topic.
    ///     let trendLink = try await atProtoKit.getTrends().trends[0].link
    ///     let trendingFeed = try await atProtoBluesky.viewTrendingFeed(trendLink)
    ///     print("Trending Feed: \(trendingFeed)")
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// - Note: The link will look something like this: `/profile/trending.bsky.app/feed/[feedID]`.
    ///
    /// If there's a `cursor` present, use the `getFeed` method to pass in the method's `atURI` and `feed`
    /// variables from the output's tuple.
    ///
    /// ```swift
    /// do {
    ///     // Continued from the first example...
    ///     let atURI = trendingFeedResult.atURI
    ///     let cursor = trendingFeedResult.posts.cursor
    ///
    ///     let getFeedContinuedResults = try await atProtoKit.getFeed(by: atURI, cursor: cursor)
    ///     print("Feed with cursor: \(getFeedContinuedResults)")
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - trendLink: The link of the trending feed.
    ///   - limit: The number of items the list will hold. Optional. Defaults to `50`.
    /// - Returns: A ftuple, which contains the feed's AT URI, as well as the posts contained in said feed.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func viewTrendingFeed(_ trendLink: String, limit: Int = 50) async throws -> (
        atURI: String,
        posts: AppBskyLexicon.Feed.GetFeedOutput
    ) {
        // Extract the feed ID.
        let feedID = trendLink.split(separator: "/")[3]

        // Compile into an AT URI to use in the `getFeed()` method.
        let atURI = "at://did:plc:qrz3lhbyuxbeilrc6nekdqme/app.bsky.feed.generator/\(feedID)"

        // Get the limit.
        var finalLimit: Int? = nil
        finalLimit = max(1, min(limit, 100))

        // Pass the URI to the method.
        let feedPosts = try await atProtoKitInstance.getFeed(by: atURI, limit: finalLimit)

        return (atURI: atURI, posts: feedPosts)
    }
}
