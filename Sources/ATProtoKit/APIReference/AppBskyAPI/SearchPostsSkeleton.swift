//
//  SearchPostsSkeleton.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-17.
//

import Foundation

extension ATProtoKit {

    /// Retrieves the skeleton results of posts.
    /// 
    /// - Important: This is an unspecced method, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Backend Posts search, returns
    /// only skeleton."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.searchPostsSkeleton`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/searchPostsSkeleton.json
    ///
    /// - Parameters:
    ///   - searchQuery: The string used for searching the users.
    ///   - sortRanking: The ranking order for the results. Optional. Defaults to `.latest`.
    ///   - sinceDate: The date and time of the results of posts created after this
    ///   time. Optional.
    ///   - untilDate: The date and time of the results of posts created before this
    ///   time. Optional.
    ///   - mentionIdentifier: The AT Identifier to filter posts that contains a given
    ///   user. Optional.
    ///   - author: Filters posts that were created by the author the AT Identifier
    ///   resolves to. Optional.
    ///   - language: Filters posts that have a specific language. Optional.
    ///   - domain: Filters result to posts containing the facet and embed links that point to
    ///   a specific domain. Optional.
    ///   - url: Filters result to posts containing facet and embed links that point to this
    ///   URL. Optional.
    ///   - tags: An array of tags to be used against the results. Optional.
    ///   - limit: The number of items that can be in the list. Optional. Defaults
    ///   to `25`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    ///  - pdsURL: The URL of the Personal Data Server (PDS). Optional.
    /// - Returns: An array of un-hydrated post records in the results, with an optional cursor to
    /// expand the array. The output may also display the total number of search results.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func searchPostsSkeleton(
        with searchQuery: String,
        sortRanking: AppBskyLexicon.Unspecced.SearchPostsSkeleton.Sort? = .latest,
        sinceDate: Date? = nil,
        untilDate: Date? = nil,
        mentionIdentifier: String? = nil,
        author: String? = nil,
        language: Locale? = nil,
        domain: String? = nil,
        url: String? = nil,
        tags: [String]? = nil,
        limit: Int? = 25,
        cursor: String? = nil,
        pdsURL: String? = nil
    ) async throws -> AppBskyLexicon.Unspecced.SearchPostsSkeletonOutput {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.searchPostsSkeleton") else {
            throw ATRequestPrepareError.invalidRequestURL
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

            let request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: nil
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Unspecced.SearchPostsSkeletonOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
