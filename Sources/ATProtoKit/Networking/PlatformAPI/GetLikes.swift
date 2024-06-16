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
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   result. Optional.
    /// - Returns: A `Result`, containing either a
    /// ``AppBskyLexicon/Feed/GetLikesOutput``
    /// if successful, or an `Error` if not.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getLikes(
        from recordURI: String,
        recordCID: String? = nil,
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> Result<AppBskyLexicon.Feed.GetLikesOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getLikes") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
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

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: AppBskyLexicon.Feed.GetLikesOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
