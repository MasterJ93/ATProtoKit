//
//  GetFeedSkeleton.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-04.
//

import Foundation

extension ATProtoKit {
    /// Retrieves a skeleton for a feed generator.
    /// 
    /// - Important: This method will only work with a PDS that's not owned by Bluesky (example: `https://bsky.social`).
    ///
    /// - Parameters:
    ///   - feedURI: The URI of the feed generator.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of result. Optional.
    ///   - accessToken: The token used to authenticate the user. Optional.
    ///   - pdsURL: The URL of the Personal Data Server (PDS).
    /// - Returns: A `Result`, containing either a ``FeedGetFeedSkeletonOutput`` if successful, or an `Error` if not.
    public static func getFeedSkeleton(_ feedURI: String, limit: Int? = 50, cursor: String? = nil,
                                       pdsURL: String) async throws -> Result <FeedGetFeedSkeletonOutput, Error> {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/app.bsky.feed.getFeedSkeleton") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        if pdsURL == "https://bsky.social" {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "This PDS will not work. Please use a different one."]))
        }
        var queryItems = [(String, String)]()

        queryItems.append(("feed", feedURI))

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: nil,
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request, decodeTo: FeedGetFeedSkeletonOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
