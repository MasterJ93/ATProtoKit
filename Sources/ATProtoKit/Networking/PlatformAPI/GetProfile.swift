//
//  GetProfile.swift
//  
//
//  Created by Christopher Jr Riley on 2024-02-18.
//

import Foundation

extension ATProtoKit {
    // TODO: Clarify with Bluesky if this is still valid.
//    /// If you need detailed information, make sure to pass in an `accessTokem`. If an `accessToken` is not given the details will be more limited.
    /// Gets a detailed profile of the user.
    ///
    /// - Parameters:
    ///   - actor: The handle or decentralized identifier (DID) of the user's account.
    /// - Returns: A `Result`, containing `ActorGetProfileOutput` if successful, or an `Error` if not.
    public func getProfile(_ actor: ActorGetProfileQuery) async throws -> Result<ActorGetProfileOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.actor.getProfile") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        // If it turns out auth isn't required, remove this line of code.
        let authorizationValue = "Bearer \(session.accessToken)"

        // Use guard to check if accessToken is non-nil and non-empty, otherwise set authorizationValue to nil.
//        let authorizationValue: String? = {
//            guard let token = accessToken, !token.isEmpty else { return nil }
//            return "Bearer \(token)"
//        }()

        var queryItems = [("actor", actor.actor)]

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL, andMethod: .get, contentTypeValue: nil, authorizationValue: authorizationValue)
            let actorProfileViewDetailedResult = try await APIClientService.sendRequest(request, decodeTo: ActorProfileViewDetailed.self)

            let result = ActorGetProfileOutput(actorProfileView: actorProfileViewDetailedResult)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}
