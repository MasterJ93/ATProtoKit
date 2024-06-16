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
    /// - Note: According to the AT Protocol specifications: "Find posts matching search criteria,
    /// returning views of those posts."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.searchPosts`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/searchPosts.json
    ///
    /// - Parameters:
    ///   - searchQuery: The string being searched against. Lucene query syntax recommended.
    ///   - sortRanking: The ranking order for the results. Optional. Defaults to `.latest`.
    ///   - sinceDate: The date and time of the results of posts created after this
    ///   time. Optional.
    ///   - untilDate: The date and time of the results of posts created before this
    ///   time. Optional.
    ///   - mentionIdentifier: The AT Identifier to filter posts that contains a given
    ///   user. Optional.
    ///   - author: Filters posts that were created by the author the AT Identifier resolves
    ///   to. Optional.
    ///   - language: Filters posts that have a specific language. Optional.
    ///   - domain: Filters result to posts containing the facet and embed links that point to a
    ///   specific domain. Optional.
    ///   - url: Filters result to posts containing facet and embed links that point to this
    ///   URL. Optional.
    ///   - tags: An array of tags to be used against the results. Optional.
    ///   - limit: The number of suggested users to follow. Optional. Defaults to `25`.
    ///   Can only choose between `1` and `100`.
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   results. Optional.
    /// - Returns: A `Result`, containing either an
    /// ``AppBskyLexicon/Feed/SearchPostsOutput``
    /// if succesful, or an `Error` if it's not.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func searchPosts(
        with searchQuery: String,
        sortRanking: AppBskyLexicon.Feed.SearchPosts.SortRanking? = .latest,
        sinceDate: Date?,
        untilDate: Date?,
        mentionIdentifier: String? = nil,
        author: String? = nil,
        language: Locale?,
        domain: String?,
        url: String?,
        tags: [String]?,
        limit: Int? = 25,
        cursor: String? = nil
    ) async throws -> Result<AppBskyLexicon.Feed.SearchPostsOutput, Error> {
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

        if let sortRanking {
            queryItems.append(("sort", "\(sortRanking.rawValue)"))
        }

        if let createdAfterDate = sinceDate, let formattedCreatedAfter = CustomDateFormatter.shared.string(from: createdAfterDate) {
            queryItems.append(("since", formattedCreatedAfter))
        }

        if let createdBeforeDate = untilDate, let formattedCreatedBefore = CustomDateFormatter.shared.string(from: createdBeforeDate) {
            queryItems.append(("until", formattedCreatedBefore))
        }

        if let mentionIdentifier {
            queryItems.append(("mentions", mentionIdentifier))
        }

        if let author {
            queryItems.append(("author", author))
        }

        if let language {
            queryItems.append(("lang", language.identifier))
        }

        if let domain {
            queryItems.append(("domain", domain))
        }

        if let url {
            queryItems.append(("url", url))
        }

        if let tags {
            queryItems += tags.map { ("tag", $0) }
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
                                                                  decodeTo: AppBskyLexicon.Feed.SearchPostsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }

    }
}
