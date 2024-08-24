//
//  GetQuotes.swift
//
//
//  Created by Christopher Jr Riley on 2024-08-23.
//

import Foundation

extension ATProtoKit {

    /// Gets an array of quuote posts that has embeded a given post.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of quotes for a
    /// given post."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getQuotes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getQuotes.json
    ///
    ///
    public func getQuotes(
        from postURI: String,
        postCID: String?,
        limit: Int? = 50
    ) async throws -> AppBskyLexicon.Feed.GetQuotesOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getQuotes") else {
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
                decodeTo: AppBskyLexicon.Feed.GetQuotesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
