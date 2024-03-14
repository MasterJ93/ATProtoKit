//
//  GetFeedGenerator.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-04.
//

import Foundation

extension ATProtoKit {
    /// Retrieves information about a given feed generator.
    /// 
    /// - Note: If you need information about multiple feed generators, it's best to use ``getFeedGenerators(_:)`` instead.
    ///
    /// - Parameter feedURI: The URI of the feed generator.
    /// - Returns: A `Result`, containing either a ``FeedGetFeedGeneratorOutput`` if successful, or an `Error` if not.
    public func getFeedGenerator(_ feedURI: String) async throws -> Result<FeedGetFeedGeneratorOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getFeedGenerator") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
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
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, decodeTo: FeedGetFeedGeneratorOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
