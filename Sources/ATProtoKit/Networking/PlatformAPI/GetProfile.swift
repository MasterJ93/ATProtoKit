//
//  GetProfile.swift
//  
//
//  Created by Christopher Jr Riley on 2024-02-18.
//

import Foundation

extension ATProtoKit {

    /// Gets a detailed profile of a user.
    ///
    /// If you need detailed information, make sure to set `shouldAuthenticate` to `true`. If
    /// `shouldAuthenticate` is `false`, then the details will be more limited.
    ///
    /// - Note: If your Personal Data Server's (PDS) URL is something other than
    /// `https://bsky.social` and you're not using authentication, be sure to change it if the
    /// normal URL isn't used for unauthenticated API calls.\
    ///\
    /// If you need profiles of several users, it's best to use
    /// ``getProfiles(_:pdsURL:shouldAuthenticate:)``.
    ///
    /// - Note: According to the AT Protocol specifications: "Get detailed profile view of an
    /// actor. Does not require auth, but contains relevant metadata with auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.getProfile`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getProfile.json
    ///
    /// - Parameters:
    ///   - actor: The handle or decentralized identifier (DID) of the user's account.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    ///   - shouldAuthenticate: Indicates whether the method will use the access token when
    ///   sending the request. Defaults to `false`.
    /// - Returns: A `Result`, containing
    /// ``AppBskyLexicon/Actor/GetProfileOutput``
    /// if successful, or an `Error` if not.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getProfile(
        _ actor: String,
        pdsURL: String? = nil,
        shouldAuthenticate: Bool = false
    ) async throws -> Result<AppBskyLexicon.Actor.GetProfileOutput, Error> {
        let authorizationValue = prepareAuthorizationValue(
            methodPDSURL: pdsURL,
            shouldAuthenticate: shouldAuthenticate,
            session: session
        )

        let finalPDSURL = determinePDSURL(customPDSURL: pdsURL)

        guard let requestURL = URL(string: "\(finalPDSURL)/xrpc/app.bsky.actor.getProfile") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let queryItems = [
            ("actor", actor)
        ]

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
            let result = try await APIClientService.sendRequest(request,
                                                                decodeTo: AppBskyLexicon.Actor.GetProfileOutput.self)

            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}
