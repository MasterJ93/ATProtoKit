//
//  GetKnownFollowers.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-12.
//

import Foundation

extension ATProtoKit {

    /// Identifies mutual followers.
    /// 
    /// - Note: According to the AT Protocol specifications: "Enumerates accounts which follow a
    /// specified account (actor) and are followed by the viewer."
    /// 
    /// - SeeAlso: This is based on the [`app.bsky.graph.getKnownFollowers`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getKnownFollowers.json
    /// 
    /// - Parameters:
    ///   - actor: The user account to check for mutual followers.
    ///   - limit: The number of items the list will hold. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of mutual followers, information aabout the user account itself,
    /// and an optional cursor for extending the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getKnownFollowers(
        from actor: String,
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> AppBskyLexicon.Graph.GetKnownFollowersOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.getKnownFollowers") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Graph.GetKnownFollowersOutput.self
            )

            return response

        } catch {
            throw error
        }
    }
}
