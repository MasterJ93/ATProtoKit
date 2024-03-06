//
//  GetTimeline.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-06.
//

import Foundation

extension ATProtoKit {
    /// Gets the user account's timeline.
    /// 
    /// - Note: Ever since the introduction of feed generators, The `algorithm` value has lost most of its usefulness. It's best to use methods such
    /// as ``getFeedGenerators(_:)`` and combine them with this method if you want to tweak how the timeline works.
    ///
    /// - Parameters:
    ///   - algorithm: The selected "algorithm" to use. Defaults to a reverse-chronological order if no value is inserted.
    ///   - limit: The number of items the list will hold. Optional. Defaults to `50`. Can only be between `1` and `100`.
    ///   - cursor: The mark used to indicate the starting point for the next set of result. Optional.
    /// - Returns: A `Result`, containing either a ``FeedGetTimelineOutput`` if successful, or an `Error` if not.
    public func getTimeline(using algorithm: String? = nil, limit: Int? = 50, cursor: String? = nil) async throws -> Result<FeedGetTimelineOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getTimeline") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        var queryItems = [(String, String)]()
        if let algorithm {
            queryItems.append(("algorithm", algorithm))
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
            let response = try await APIClientService.sendRequest(request, decodeTo: FeedGetTimelineOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
