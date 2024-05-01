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
    /// - Note: According to the AT Protocol specifications: "Enumerates follows similar to
    /// a given account (actor). Expected use is to recommend additional accounts immediately
    /// after following one account."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getSuggestedFollowsByActor`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getSuggestedFollowsByActor.json
    ///
    /// - Parameter actorDID: The decentralized identifier (DID) or handle of the user account
    /// that the suggestions are based on.
    /// - Returns: A `Result`, containing either a ``GraphGetSuggestedFollowsByActorOutput``
    /// if successful, or an `Error` if not.
    public func getSuggestedFollowsByActor(_ actorDID: String) async throws -> Result<GraphGetSuggestedFollowsByActorOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.getSuggestedFollowsByActor") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        queryItems.append(("actor", actorDID))

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )
            print("QueryURL: \(queryURL)")

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: GraphGetSuggestedFollowsByActorOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
