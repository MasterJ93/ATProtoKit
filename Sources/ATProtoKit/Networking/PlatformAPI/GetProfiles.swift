//
//  GetProfiles.swift
//  
//
//  Created by Christopher Jr Riley on 2024-02-19.
//

import Foundation

extension ATProtoKit {
    // TODO: Finish this method to make it work with the parameters that's stated in the Bluesky docs.
    /// Gets detailed profiles of several users.
    ///
    /// If you need detailed information, make sure to pass in an `accessToken`. If an `accessToken` is not given the details will be more limited.
    /// 
    /// - Note: If your Personal Data Server's (PDS) URL is something other than `https://bsky.social` and you're not using authentication, be sure to change it if the normal URL isn't used
    /// for unauthenticated API calls.\
    /// \
    /// If you need a profile of just one user, it's best to use ``getProfile(_:accessToken:pdsURL:)``
    ///
    /// - Parameters:
    ///   - actors: An array of user account handles or decentralized identifiers (DID). Current maximum length is 25 handles and/or DIDs.
    ///   - accessToken: The access token of the user.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    /// - Returns: A `Result`, containing `ActorGetProfileOutput` if successful, or an `Error` if not.
    public static func getProfiles(_ actors: ActorGetProfilesQuery,
                                   accessToken: String? = nil,
                                   pdsURL: String? = "https://bsky.social") async throws -> Result<ActorGetProfilesOutput, Error> {
        let finalPDSURL = determinePDSURL(accessToken: accessToken, customPDSURL: pdsURL)

        guard let requestURL = URL(string: "\(finalPDSURL)/xrpc/app.bsky.actor.getProfiles") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        // Use guard to check if accessToken is non-nil and non-empty, otherwise set authorizationValue to nil.
        let authorizationValue: String? = {
            guard let token = accessToken, !token.isEmpty else { return nil }
            return "Bearer \(token)"
        }()

        // Add each handle/DID ($0) into their own "actors" parameter.
        let queryItems = actors.actors.map { ("actors", $0) }

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            print("===Query URL: \(queryURL)")

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         contentTypeValue: nil,
                                                         authorizationValue: authorizationValue)
            let actorProfileViewsDetailedResult = try await APIClientService.sendRequest(request, decodeTo: ActorGetProfilesOutput.self)

            return .success(actorProfileViewsDetailedResult)
        } catch {
            return .failure(error)
        }
    }
}
