//
//  UnmuteActor.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-10.
//

import Foundation

extension ATProtoKit {

    /// Unmutes a user account.
    /// 
    /// - Note: According to the AT Protocol specifications: "Unmutes the specified account.
    /// Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.unmuteActor`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/unmuteActor.json
    ///
    /// - Parameter actor: The AT Identifier or handle of a user account.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func unmuteActor(_ actor: String) async throws {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.unmuteActor") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AppBskyLexicon.Graph.UnmuteActorRequestBody(
            actor: actor
        )

        do {
            let request = await APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )

            _ = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
