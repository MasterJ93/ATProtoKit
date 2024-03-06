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
    /// - Parameters:
    ///   - postURI: The URI of the post record.
    ///   - postCID: The CID hasg of the post record. Optional.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of result. Optional.
    /// - Returns: A `Result`, containing either a ``FeedGetRepostedBy`` if successful, or an `Error` if not.
    public func getRepostedBy(_ postURI: String, postCID: String? = nil, limit: Int? = 50, cursor: String? = nil) async throws -> Result<FeedGetRepostedBy, Error>{
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getRepostedBy") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        var queryItems = [(String, String)]()

        queryItems.append(("uri", postURI))

        if let postCID {
            queryItems.append(("cid", postCID))
        }

        if let limit {
            let finalLimit = min(1, max(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
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
            let response = try await APIClientService.sendRequest(request, decodeTo: FeedGetRepostedBy.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
