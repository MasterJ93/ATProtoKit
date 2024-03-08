//
//  GetFollows.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-08.
//

import Foundation

extension ATProtoKit {
    /// Gets all of the accounts the user account follows.
    ///
    public func getFollows(from atActor: String, limit: Int? = 50, cursor: String? = nil) async throws -> Result<GraphFollowsOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.getFollows") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        var queryItems = [(String, String)]()

        queryItems.append(("actor", atActor))

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
            let response = try await APIClientService.sendRequest(request, decodeTo: GraphFollowsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
