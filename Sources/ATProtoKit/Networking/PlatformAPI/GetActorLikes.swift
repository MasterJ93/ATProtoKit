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
    /// - Note: Despite the fact that the documentation in the AT Protocol specifications say that
    /// this API call doesn't require auth, testing shows that this is not true. It's unclear
    /// whether this is intentional (and therefore, the documentation is outdated) or unintentional
    /// (in this case, the underlying implementation is outdated). For now, this method will act as
    /// if auth is required until Bluesky clarifies their position.
    ///
    /// - Important: This will only be able to get like records for the authenticated account.
    /// This won't work for any other user account. If you need to grab the like records for user
    /// accounts other than the authenticated one, use
    /// ``listRecords(from:collection:limit:cursor:isArrayReverse:pdsURL:)`` instead.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of posts liked by an
    /// actor. Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getActorLikes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getActorLikes.json
    ///
    /// - Parameters:
    ///   - actorDID: The decentralized identifier (DID) of the user account.
    ///   - limit: The number of items the list will hold. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   result. Optional.
    /// - Returns: A `Result`, containing either a
    /// ``AppBskyLexicon/Feed/GetActorLikesOutput``
    /// if successful, or an `Error` if not.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getActorLikes(
        by actorDID: String,
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> Result<AppBskyLexicon.Feed.GetActorLikesOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getActorLikes") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
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

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: AppBskyLexicon.Feed.GetActorLikesOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
