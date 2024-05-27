//
//  GetFollowers.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-08.
//

import Foundation

extension ATProtoKit {

    /// Gets all of the user account's followers.
    /// 
    /// - Note: According to the AT Protocol specifications: "Enumerates accounts which follow
    /// a specified account (actor)."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getFollowers`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getFollowers.json
    ///
    /// - Parameters:
    ///   - actorDID: The decentralized identifier (DID) or handle of the user account to search
    ///   their followers.
    ///   - limit: The number of items the list will hold. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of result. Optional.
    /// - Returns: A `Result`, containing either a ``GraphGetFollowersOutput``
    /// if successful, or an `Error` if not.
    public func getFollowers(by actorDID: String, limit: Int? = 50, cursor: String? = nil) async throws -> Result<GraphGetFollowersOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.getFollowers") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        queryItems.append(("actor", actorDID))

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

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: GraphGetFollowersOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
