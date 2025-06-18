//
//  AppBskyActorGetProfilesMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Gets detailed profiles of several users.
    ///
    /// If you need detailed information, make sure to set `shouldAuthenticate` to `true`. If
    /// `shouldAuthenticate` is `false`, then the details will be more limited.
    ///
    /// - Note: If your Personal Data Server's (PDS) URL is something other than
    /// `https://bsky.social` and you're not using authentication, be sure to change it if the
    /// normal URL isn't used for unauthenticated API calls.\
    /// \
    /// If you need a profile of just one user, it's best to use ``getProfile(for:)``.
    ///
    /// - Note: According to the AT Protocol specifications: "Get detailed profile views of
    /// multiple actors."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.getProfiles`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getProfiles.json
    ///
    /// - Parameter actors: An array of user account handles or decentralized identifiers (DID).
    ///   Current maximum length is 25 handles and/or DIDs.
    /// - Returns: An array of detailed profile views for several user accounts.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getProfiles(
        for actors: [String]
    ) async throws -> AppBskyLexicon.Actor.GetProfilesOutput {
        let authorizationValue = await prepareAuthorizationValue()

        guard let sessionURL = authorizationValue != nil ? try await self.getUserSession()?.serviceEndpoint.absoluteString : self.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.actor.getProfiles") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        let cappedActorsArray = actors.prefix(25)
        queryItems += cappedActorsArray.map { ("actors", $0) }

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
                decodeTo: AppBskyLexicon.Actor.GetProfilesOutput.self
            )

            return result
        } catch {
            throw error
        }
    }
}
