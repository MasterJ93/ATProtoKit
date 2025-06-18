//
//  AppBskyActorGetProfileMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-18.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
    /// If you need profiles of several users, it's best to use ``getProfiles(for:)`` instead.
    ///
    /// - Note: According to the AT Protocol specifications: "Get detailed profile view of an
    /// actor. Does not require auth, but contains relevant metadata with auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.getProfile`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getProfile.json
    ///
    /// - Parameter actor: The handle or decentralized identifier (DID) of the user's account.
    /// - Returns: A detailed profile view of the specified user account.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getProfile(
        for actor: String
    ) async throws -> AppBskyLexicon.Actor.ProfileViewDetailedDefinition {
        let authorizationValue = await prepareAuthorizationValue()

        guard let sessionURL = authorizationValue != nil ? try await self.getUserSession()?.serviceEndpoint.absoluteString : self.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.actor.getProfile") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let queryItems = [
            ("actor", actor)
        ]

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                contentTypeValue: nil,
                authorizationValue: authorizationValue
            )
            let result = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Actor.ProfileViewDetailedDefinition.self
            )

            return result
        } catch {
            throw error
        }
    }
}
