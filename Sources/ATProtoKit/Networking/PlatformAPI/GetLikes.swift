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
    /// - Parameters:
    ///   - recordURI: The URI of the record.
    ///   - recordCID: The CID hash of the subject for filtering likes.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of result. Optional.
    /// - Returns: A `Result`, containing either a ``FeedGetLikesOutput`` if successful, or an `Error` if not.
    public func getLikes(recordURI: String, recordCID: String? = nil, limit: Int? = 50, cursor: String? = nil) async throws -> Result<FeedGetLikesOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getLikes") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        var queryItems = [(String, String)]()

        queryItems.append(("uri", recordURI))

        if let recordCID {
            queryItems.append(("cid", recordCID))
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
            let response = try await APIClientService.sendRequest(request, decodeTo: FeedGetLikesOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
