//
//  GetAuthorFeed.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-04.
//

import Foundation

extension ATProtoKit {
    /// Retrieves the user account's posts and reposts.
    ///
    /// - Note: Despite the fact that the documentation in the AT Protocol specifications say that this API call doesn't require auth, testing shows that this is
    /// not true. It's unclear whether this is intentional (and therefore, the documentation is outdated) or unintentional (in this case, the underlying
    /// implementation is outdated). For now, this method will act as if auth is required until Bluesky clarifies their position.
    ///
    /// - Parameters:
    ///   - actor: The decentralized identifier (DID) of the user account.
    ///   - limit: The number of items the list will hold. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of result. Optional.
    /// - Returns: A `Result`, containing either a ``FeedGetAuthorFeedOutput`` if successful, or an `Error` if not.
    public func getAuthorFeed(by actor: String, limit: Int? = 50, cursor: String? = nil, postFilter: FeedGetAuthorFeedFilter? = .postsWithReplies) async throws -> Result<FeedGetAuthorFeedOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getAuthorFeed") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        var queryItems = [(String, String)]()

        queryItems.append(("actor", actor))

        if let limit {
            let finalLimit = min(1, max(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        if let postFilter {
            queryItems.append(("filter", "\(postFilter)"))
        }

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, decodeTo: FeedGetAuthorFeedOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
