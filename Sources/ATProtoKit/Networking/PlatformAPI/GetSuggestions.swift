//
//  GetSuggestions.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-20.
//

import Foundation

extension ATProtoKit {
    /// Gets a list of suggested users.
    /// 
    /// - Parameters:
    ///   - limit: The number of suggested users to follow. Optional. Defaults to 50. Can only choose between 1 and 100.
    ///   - cursor: The mark used to indicate the starting point for the next set of results. Optional.
    /// - Returns: A `Result`, containing either an `ActorGetSuggestionsOutput` if succesful, or an `Error` if it's not.
    public func getSuggestions(_ limit: Int? = 50, cursor: String? = nil) async throws -> Result<ActorGetSuggestionsOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.actor.getSuggestions") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        // Make sure limit is between 1 and 100.
        let finalLimit = max(1, min(limit ?? 50, 100))
        var queryItems = [("limit", "\(finalLimit)")]

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            print("QueryURL: \(queryURL)")

            let request = APIClientService.createRequest(forRequest: queryURL, andMethod: .get, authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, decodeTo: ActorGetSuggestionsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
