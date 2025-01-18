//
//  GetRepostedBy.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-06.
//

import Foundation

extension ATProtoKit {

    /// Retrieves an array of users who have reposted a given post.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get a list of reposts for a
    /// given post."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getRepostedBy`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getRepostedBy.json
    ///
    /// - Parameters:
    ///   - postURI: The URI of the post record.
    ///   - postCID: The CID hash of the post record. Optional.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of user accounts who reposted the post record, with an optional cursor
    /// for extending the array, and the URI and CID hash of the post record.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getRepostedBy(
        _ postURI: String,
        postCID: String? = nil,
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> AppBskyLexicon.Feed.GetRepostedByOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.serviceEndpoint,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getRepostedBy") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("uri", postURI))

        if let postCID {
            queryItems.append(("cid", postCID))
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
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Feed.GetRepostedByOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
