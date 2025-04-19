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
    /// - Parameters:
    ///   - postURI: The URI of the post.
    ///   - postCID: The CID hash of the post. Optional.
    ///   - limit: The number quote posts to display. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of quote posts for a given post, with an optional cursor to extend
    /// the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getQuotes(
        from postURI: String,
        postCID: String?,
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> AppBskyLexicon.Feed.GetQuotesOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getQuotes") else {
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

            let request = await APIClientService.createRequest(
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
