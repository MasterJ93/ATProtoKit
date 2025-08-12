//
//  AppBskyFeedGetFeedGeneratorsMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-04.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Retrieves information about several feed generators.
    ///
    /// - Note: If you need details about only one feed generator, it's best to use
    /// ``getFeedGenerator(by:)`` instead.
    ///
    /// - Note: According to the AT Protocol specifications: "Get information about a list
    /// of feed generators."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getFeedGenerators`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getFeedGenerators.json
    ///
    /// - Parameter uris: An array of URIs for feed generators.
    /// - Returns: An array of feed generator views, as well as their online and validity statuses.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getFeedGenerators(by uris: [String]) async throws -> AppBskyLexicon.Feed.GetFeedGeneratorsOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getFeedGenerators") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems += uris.map { ("feeds", $0) }

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
                decodeTo: AppBskyLexicon.Feed.GetFeedGeneratorsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
