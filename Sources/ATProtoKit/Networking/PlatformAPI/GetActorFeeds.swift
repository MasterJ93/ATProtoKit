//
//  GetActorFeeds.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-04.
//

import Foundation

extension ATProtoKit {
    /// Retrieving a feed list by a user.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get a list of feeds (feed generator records) created by the actor (in the actor's repo)."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getActorFeeds`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getActorFeeds.json
    ///
    /// - Parameters:
    ///   - actorDID: The decentralized identifier (DID) of the user who created the feeds.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of result. Optional.
    /// - Returns: A `Result`, containing either a ``FeedGetActorFeedsOutput`` if successful, or an `Error` if not.
    public func getActorFeeds(by actorDID: String, limit: Int? = 50, cursor: String? = nil) async throws -> Result<FeedGetActorFeedsOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getActorFeeds") else {
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
                                                                  decodeTo: FeedGetActorFeedsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
