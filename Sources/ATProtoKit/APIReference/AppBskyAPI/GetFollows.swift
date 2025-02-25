//
//  GetFollows.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-08.
//

import Foundation

extension ATProtoKit {

    /// Gets all of the accounts the user account follows.
    /// 
    /// - Note: According to the AT Protocol specifications: "Enumerates accounts which a
    /// specified account (actor) follows."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getFollows`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getFollows.json
    ///
    /// - Parameters:
    ///   - actorDID: The decentralized identifier (DID) or handle of the user account to
    ///   search the user accounts they follow.
    ///   - limit: The number of items the list will hold. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    ///   - shouldAuthenticate: Indicates whether the method will use the access token when
    ///   sending the request. Defaults to `true`.
    /// - Returns: An array of user accounts that the user account follows, information about the
    /// user account itself, and an optional cursor for extending the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getFollows(
        from actorDID: String,
        limit: Int? = 50,
        cursor: String? = nil,
        shouldAuthenticate: Bool = true
    ) async throws -> AppBskyLexicon.Graph.GetFollowsOutput {
        let authorizationValue = prepareAuthorizationValue(
            shouldAuthenticate: shouldAuthenticate,
            session: session
        )

        guard self.pdsURL != "" else {
            throw ATRequestPrepareError.emptyPDSURL
        }

        guard let sessionURL = authorizationValue != nil ? session?.serviceEndpoint.absoluteString : self.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.getFollows") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("actor", actorDID))

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: authorizationValue
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Graph.GetFollowsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
