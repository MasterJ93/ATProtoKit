//
//  GetFeedGenerator.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-04.
//

import Foundation

extension ATProtoKit {

    /// Retrieves information about a given feed generator.
    /// 
    /// - Note: If you need information about multiple feed generators, it's best to use
    /// ``getFeedGenerators(by:)`` instead.
    ///
    /// - Note: According to the AT Protocol specifications: "Get information about a
    /// feed generator. Implemented by AppView."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getFeedGenerator`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getFeedGenerator.json
    ///
    /// - Parameter uri: The URI of the feed generator.
    /// - Returns: A view of the feed generator, as well as its online and validity status.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getFeedGenerator(by uri: String) async throws -> AppBskyLexicon.Feed.GetFeedGeneratorOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getFeedGenerator") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("feed", uri))

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
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Feed.GetFeedGeneratorOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
