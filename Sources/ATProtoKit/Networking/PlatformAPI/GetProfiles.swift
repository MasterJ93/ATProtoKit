//
//  GetProfiles.swift
//  
//
//  Created by Christopher Jr Riley on 2024-02-19.
//

import Foundation

extension ATProtoKit {
    /// Gets detailed profiles of several users.
    ///
    /// If you need detailed information, make sure to set `shouldAuthenticate` to `true`. If `shouldAuthenticate` is `false`, then the details will be more limited.
    ///
    /// - Note: If your Personal Data Server's (PDS) URL is something other than `https://bsky.social` and you're not using authentication, be sure to change it if the normal URL isn't used
    /// for unauthenticated API calls.\
    /// \
    /// If you need a profile of just one user, it's best to use ``getProfile(_:accessToken:pdsURL:)``
    ///
    /// - Note: According to the AT Protocol specifications: "Get detailed profile views of multiple actors."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.getProfiles`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getProfiles.json
    ///
    /// - Parameters:
    ///   - actors: An array of user account handles or decentralized identifiers (DID). Current maximum length is 25 handles and/or DIDs.
    ///   - accessToken: The access token of the user.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    ///   - shouldAuthenticate: Indicates whether the method will use the access token when sending the request. Defaults to `false`.
    /// - Returns: A `Result`, containing `ActorGetProfileOutput` if successful, or an `Error` if not.
    public func getProfiles(_ actors: [String],
                            pdsURL: String? = nil,
                            shouldAuthenticate: Bool = false) async throws -> Result<ActorGetProfilesOutput, Error> {
        var accessToken: String? = nil

        if shouldAuthenticate == true {
            guard session != nil,
                  accessToken == session?.accessToken else {
                throw ATRequestPrepareError.missingActiveSession
            }
        }

        let finalPDSURL = determinePDSURL(customPDSURL: pdsURL)

        guard let requestURL = URL(string: "\(finalPDSURL)/xrpc/app.bsky.actor.getProfiles") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        // Use guard to check if accessToken is non-nil and non-empty, otherwise set authorizationValue to nil.
        let authorizationValue: String? = {
            guard let token = accessToken, !token.isEmpty else { return nil }
            return "Bearer \(token)"
        }()

        var queryItems = [(String, String)]()

        var cappedActorsArray = actors.prefix(25)
        queryItems += cappedActorsArray.map { ("actors", $0) }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         contentTypeValue: nil,
                                                         authorizationValue: authorizationValue)
            let actorProfileViewsDetailedResult = try await APIClientService.sendRequest(request,
                                                                                         decodeTo: ActorGetProfilesOutput.self)

            return .success(actorProfileViewsDetailedResult)
        } catch {
            return .failure(error)
        }
    }
}
