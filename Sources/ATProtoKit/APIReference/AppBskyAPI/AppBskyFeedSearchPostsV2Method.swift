//
//  AppBskyFeedSearchPostsV2Method.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-10.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Retrieves the results of a v2 search query.
    ///
    /// - Note: According to the AT Protocol specifications: "Find posts matching a search query
    /// or filters, returning search hits for matching post records."
    ///
    /// - Note: A `query` string or at least one filter parameter is required.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.searchPostsV2`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/searchPostsV2.json
    ///
    /// - Parameters:
    ///   - query: Search query string. Optional, but a query or at least one filter is required.
    ///   - sort: Ranking order for results. Optional.
    ///   - authors: Include posts by any of these authors (AT Identifiers). Optional.
    ///   - mentions: Include posts that mention any of these accounts (AT Identifiers). Optional.
    ///   - domains: Include posts that link to any of these domains. Optional.
    ///   - urls: Include posts that link to any of these URLs. Optional.
    ///   - embeddedAtURIs: Include posts that embed any of these AT URIs. Optional.
    ///   - hashtags: Include posts tagged with any of these hashtags (without the `#` prefix). Optional.
    ///   - excludeAuthors: Exclude posts by any of these authors (AT Identifiers). Optional.
    ///   - excludeMentions: Exclude posts mentioning any of these accounts (AT Identifiers). Optional.
    ///   - excludeDomains: Exclude posts linking to any of these domains. Optional.
    ///   - excludeURLs: Exclude posts linking to any of these URLs. Optional.
    ///   - excludeEmbeddedAtURIs: Exclude posts embedding any of these AT URIs. Optional.
    ///   - excludeHashtags: Exclude posts tagged with any of these hashtags (without the `#` prefix). Optional.
    ///   - since: Include posts indexed at or after this date and time. Optional.
    ///   - until: Include posts indexed before this date and time. Defaults to the current time. Optional.
    ///   - allTime: Search the full index instead of the recent-post window. Optional.
    ///   - languages: Include posts whose language matches any of these language codes. Optional.
    ///   - excludeLanguages: Exclude posts whose language matches any of these language codes. Optional.
    ///   - hasMedia: Include only posts with media. Optional.
    ///   - hasVideo: Include only posts with video. Optional.
    ///   - replyParentURI: Include only direct replies to this parent post URI. Optional.
    ///   - threadRootURI: Include only posts in the thread rooted at this post URI. Optional.
    ///   - excludeReplies: Exclude replies from results. Mutually exclusive with `repliesOnly`. Optional.
    ///   - repliesOnly: Include only replies. Mutually exclusive with `excludeReplies`. Optional.
    ///   - following: Include only posts from accounts followed by the viewer. Optional.
    ///   - queryLanguage: Language analyzer hint for the query text. Optional.
    ///   - limit: The number of results to return. Optional. Defaults to `25`.
    ///   Can only choose between `1` and `100`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    ///   - labelersValue: The `atproto-accept-labelers` header value, containing the labeler
    ///   services whose labels should be applied to the response. Optional.
    /// - Returns: An array of post records in the results, with an optional cursor to expand
    /// the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func searchPostsV2(
        matching query: String? = nil,
        sort: AppBskyLexicon.Feed.SearchPostsV2.SortRanking? = nil,
        authors: [String]? = nil,
        mentions: [String]? = nil,
        domains: [String]? = nil,
        urls: [String]? = nil,
        embeddedAtURIs: [String]? = nil,
        hashtags: [String]? = nil,
        excludeAuthors: [String]? = nil,
        excludeMentions: [String]? = nil,
        excludeDomains: [String]? = nil,
        excludeURLs: [String]? = nil,
        excludeEmbeddedAtURIs: [String]? = nil,
        excludeHashtags: [String]? = nil,
        since: Date? = nil,
        until: Date? = nil,
        allTime: Bool? = nil,
        languages: [String]? = nil,
        excludeLanguages: [String]? = nil,
        hasMedia: Bool? = nil,
        hasVideo: Bool? = nil,
        replyParentURI: String? = nil,
        threadRootURI: String? = nil,
        excludeReplies: Bool? = nil,
        repliesOnly: Bool? = nil,
        following: Bool? = nil,
        queryLanguage: AppBskyLexicon.Feed.SearchPostsV2.QueryLanguage? = nil,
        limit: Int? = 25,
        cursor: String? = nil,
        labelersValue: String? = nil
    ) async throws -> AppBskyLexicon.Feed.SearchPostsV2Output {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.searchPostsV2") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let query {
            queryItems.append(("query", query))
        }

        if let sort {
            queryItems.append(("sort", sort.rawValue))
        }

        if let authors {
            queryItems += authors.map { ("authors", $0) }
        }

        if let mentions {
            queryItems += mentions.map { ("mentions", $0) }
        }

        if let domains {
            queryItems += domains.map { ("domains", $0) }
        }

        if let urls {
            queryItems += urls.map { ("urls", $0) }
        }

        if let embeddedAtURIs {
            queryItems += embeddedAtURIs.map { ("embeddedAtUris", $0) }
        }

        if let hashtags {
            queryItems += hashtags.map { ("hashtags", $0) }
        }

        if let excludeAuthors {
            queryItems += excludeAuthors.map { ("excludeAuthors", $0) }
        }

        if let excludeMentions {
            queryItems += excludeMentions.map { ("excludeMentions", $0) }
        }

        if let excludeDomains {
            queryItems += excludeDomains.map { ("excludeDomains", $0) }
        }

        if let excludeURLs {
            queryItems += excludeURLs.map { ("excludeUrls", $0) }
        }

        if let excludeEmbeddedAtURIs {
            queryItems += excludeEmbeddedAtURIs.map { ("excludeEmbeddedAtUris", $0) }
        }

        if let excludeHashtags {
            queryItems += excludeHashtags.map { ("excludeHashtags", $0) }
        }

        if let since, let formattedSince = CustomDateFormatter.shared.string(from: since) {
            queryItems.append(("since", formattedSince))
        }

        if let until, let formattedUntil = CustomDateFormatter.shared.string(from: until) {
            queryItems.append(("until", formattedUntil))
        }

        if let allTime {
            queryItems.append(("allTime", "\(allTime)"))
        }

        if let languages {
            queryItems += languages.map { ("languages", $0) }
        }

        if let excludeLanguages {
            queryItems += excludeLanguages.map { ("excludeLanguages", $0) }
        }

        if let hasMedia {
            queryItems.append(("hasMedia", "\(hasMedia)"))
        }

        if let hasVideo {
            queryItems.append(("hasVideo", "\(hasVideo)"))
        }

        if let replyParentURI {
            queryItems.append(("replyParentUri", replyParentURI))
        }

        if let threadRootURI {
            queryItems.append(("threadRootUri", threadRootURI))
        }

        if let excludeReplies {
            queryItems.append(("excludeReplies", "\(excludeReplies)"))
        }

        if let repliesOnly {
            queryItems.append(("repliesOnly", "\(repliesOnly)"))
        }

        if let following {
            queryItems.append(("following", "\(following)"))
        }

        if let queryLanguage {
            queryItems.append(("queryLanguage", queryLanguage.rawValue))
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
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                requiresAuthorization: true,
                labelersValue: labelersValue
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Feed.SearchPostsV2Output.self
            )

            return response
        } catch {
            throw error
        }
    }
}
