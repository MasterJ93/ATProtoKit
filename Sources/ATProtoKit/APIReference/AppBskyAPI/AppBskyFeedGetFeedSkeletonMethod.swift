//
//  AppBskyFeedGetFeedSkeletonMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-04.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Retrieves a skeleton for a feed generator.
    /// 
    /// - Important: This method will only work with a PDS that's not owned by Bluesky
    /// (example: `https://bsky.social`).
    ///
    /// - Note: According to the AT Protocol specifications: "Get a skeleton of a feed provided
    /// by a feed generator. Auth is optional, depending on provider requirements, and provides
    /// the DID of the requester. Implemented by Feed Generator Service."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getFeedSkeleton`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getFeedSkeleton.json
    ///
    /// - Parameters:
    ///   - uri: The URI of the feed generator.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of skeleton feeds, with an optional cursor to extend the array. May also
    /// contain a request identifier after an interaction has been established.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getFeedSkeleton(
        by uri: String,
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> AppBskyLexicon.Feed.GetFeedSkeletonOutput {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/app.bsky.feed.getFeedSkeleton") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        if self.pdsURL == "https://bsky.social" {
            throw ATRequestPrepareError.invalidPDS
        }

        var queryItems = [(String, String)]()

        queryItems.append(("feed", uri))

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: nil,
                contentTypeValue: "application/json",
                authorizationValue: nil
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Feed.GetFeedSkeletonOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
