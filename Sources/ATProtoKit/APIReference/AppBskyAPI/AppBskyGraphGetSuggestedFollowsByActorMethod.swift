//
//  AppBskyGraphGetSuggestedFollowsByActorMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-10.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
    /// - Parameter actor: The AT Identifier or handle of the user account that the suggestions
    /// are based on.
    /// - Returns: An array of user accounts the requesting user account is suggested to follow and
    /// a snowflake ID for recommendations.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSuggestedFollowsByActor(_ actor: String) async throws -> AppBskyLexicon.Graph.GetSuggestedFollowsByActorOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.getSuggestedFollowsByActor") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("actor", actor))

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Graph.GetSuggestedFollowsByActorOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
