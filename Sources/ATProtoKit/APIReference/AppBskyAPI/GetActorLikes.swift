//
//  GetActorLikes.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-04.
//

import Foundation

extension ATProtoKit {

    /// Retrieves all of the user account's likes.
    ///
    /// - Important: This will only be able to get like records for the authenticated account.
    /// This won't work for any other user account. If you need to grab the like records for user
    /// accounts other than the authenticated one, use
    /// ``listRecords(from:collection:limit:cursor:isArrayReverse:pdsURL:)`` instead.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of posts liked by an
    /// actor. Requires auth, actor must be the requesting account."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getActorLikes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getActorLikes.json
    ///
    /// - Parameters:
    ///   - actorDID: The decentralized identifier (DID) of the user account.
    ///   - limit: The number of items the list will hold. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of like records from the user account, with an optional cursor
    /// for extending the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getActorLikes(
        by actorDID: String,
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> AppBskyLexicon.Feed.GetActorLikesOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getActorLikes") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("actor", actorDID))

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
                decodeTo: AppBskyLexicon.Feed.GetActorLikesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
