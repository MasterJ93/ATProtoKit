//
//  GetLikes.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-04.
//

import Foundation

extension ATProtoKit {

    /// Retrieves like records of a specific subject.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get like records which reference a
    /// subject (by AT-URI and CID)."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getLikes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getLikes.json
    ///
    /// - Parameters:
    ///   - recordURI: The URI of the record.
    ///   - recordCID: The CID hash of the subject for filtering likes.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of likes for the specified record, including an optional cursor
    /// for extending the array, as well as the URI and CID hash of the record itself.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getLikes(
        from recordURI: String,
        recordCID: String? = nil,
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> AppBskyLexicon.Feed.GetLikesOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.serviceEndpoint,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getLikes") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("uri", recordURI))

        if let recordCID {
            queryItems.append(("cid", recordCID))
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
                decodeTo: AppBskyLexicon.Feed.GetLikesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
