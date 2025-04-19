//
//  UnmuteThread.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-16.
//

import Foundation

extension ATProtoKit {

    /// Unmutes a thread.
    /// 
    /// - Note: According to the AT Protocol specifications: "Unmutes the specified thread.
    /// Requires auth"
    /// 
    /// - SeeAlso: This is based on the [`app.bsky.graph.unmuteThread`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/unmuteThread.json
    /// 
    /// - Parameter rootURI: The URI of the root of the post.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func unmuteThread(_ rootURI: String) async throws {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.unmuteThread") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AppBskyLexicon.Graph.UnmuteThreadRequestBody(
            rootURI: rootURI
        )

        do {
            let request = await APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
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
