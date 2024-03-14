//
//  GetFeedGenerators.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-04.
//

import Foundation

extension ATProtoKit {
    /// Retrieves information about several feed generators.
    ///
    /// - Note: If you need details about only one feed generator, it's best to use ``getFeedGenerator(_:)`` instead.
    /// 
    /// - Parameter feedURIs: An array of URIs for feed generators.
    /// - Returns: A `Result`, containing either a ``FeedGetFeedGeneratorOutput`` if successful, or an `Error` if not.
    public func getFeedGenerators(_ feedURIs: [String]) async throws -> Result<FeedGetFeedGeneratorsOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getFeedGenerators") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        var queryItems = [(String, String)]()

        queryItems += feedURIs.map { ("feeds", $0) }

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
            let response = try await APIClientService.sendRequest(request, decodeTo: FeedGetFeedGeneratorsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
