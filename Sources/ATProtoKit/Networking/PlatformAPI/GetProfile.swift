//
//  GetProfile.swift
//  
//
//  Created by Christopher Jr Riley on 2024-02-18.
//

import Foundation

extension ATProtoKit {
    /// Gets a detailed profile of the user.
    ///
    /// If you need detailed information, make sure to pass in an `accessToken`. If an `accessToken` is not given the details will be more limited.
    /// - Note: If your Personal Data Server's (PDS) URL is something other than `https://bsky.social` and you're not using authentication, be sure to change it if the normal URL isn't used for unauthenticated API calls.
    /// - Parameters:
    ///   - actor: The handle or decentralized identifier (DID) of the user's account.
    ///   - accessToken: The access token of the user.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    /// - Returns: A `Result`, containing `ActorGetProfileOutput` if successful, or an `Error` if not.
    public static func getProfile(_ actor: ActorGetProfileQuery, accessToken: String? = nil, pdsURL: String? = "https://bsky.social") async throws -> Result<ActorGetProfileOutput, Error> {
        let finalPDSURL = determinePDSURL(accessToken: accessToken, customPDSURL: pdsURL)

        guard let requestURL = URL(string: "\(finalPDSURL)/xrpc/app.bsky.actor.getProfile") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        // Use guard to check if accessToken is non-nil and non-empty, otherwise set authorizationValue to nil.
        let authorizationValue: String? = {
            guard let token = accessToken, !token.isEmpty else { return nil }
            return "Bearer \(token)"
        }()

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
