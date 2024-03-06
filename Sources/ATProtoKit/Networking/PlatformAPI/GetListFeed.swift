//
//  GetListFeed.swift
//  
//
//  Created by Christopher Jr Riley on 2024-03-06.
//

import Foundation

extension ATProtoKit {
    /// Retireves recent posts and reposts from a given feed.
    /// 
    /// - Parameters:
    ///   - listURI: The URI of the feed.
    ///   - limit: limit: The number of suggested users to follow. Optional. Defaults to `50`. Can only choose between `1` and `100`.
    ///   - cursor: The mark used to indicate the starting point for the next set of results. Optional.
    ///   - accessToken: The access token of the user. Optional.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Optional. Defaults to `https://bsky.social`
    /// - Returns: A `Result`, containing either an ``FeedGetListFeedOutput`` if succesful, or an `Error` if it's not.
    public static func getListFeed(from listURI: String, limit: Int? = 50, cursor: String? = nil,
                                   accessToken: String? = nil,
                                   pdsURL: String = "https://bsky.social") async throws -> Result<FeedGetListFeedOutput, Error> {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/app.bsky.feed.getListFeed") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        // Use guard to check if accessToken is non-nil and non-empty, otherwise set authorizationValue to nil.
        let authorizationValue: String? = {
            guard let token = accessToken, !token.isEmpty else { return nil }
            return "Bearer \(token)"
        }()

        var queryItems = [(String, String)]()

        queryItems.append(("list", listURI))

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
                                                         authorizationValue: authorizationValue)
            let response = try await APIClientService.sendRequest(request, decodeTo: FeedGetListFeedOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
