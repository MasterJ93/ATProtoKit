//
//  GetSuggestedFollowsByActor.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-10.
//

import Foundation

extension ATProtoKit {
    /// Gets the list of user accounts that requesting user account is suggested to follow.
    /// 
    /// - Parameter actorDID: The decentralized identifier (DID) or handle of the user account that the suggestions are based on.
    /// - Returns: A `Result`, containing either a ``GraphGetSuggestedFollowsByActorOutput`` if successful, or an `Error` if not.
    public func getSuggestedFollowsByActor(_ actorDID: String) async throws -> Result<GraphGetSuggestedFollowsByActorOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.getSuggestedFollowsByActor") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        var queryItems = [(String, String)]()

        queryItems.append(("actor", actorDID))

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )
            print("QueryURL: \(queryURL)")

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, decodeTo: GraphGetSuggestedFollowsByActorOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
