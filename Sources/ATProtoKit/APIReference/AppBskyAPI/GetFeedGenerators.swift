//
//  GetFeedGenerators.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-04.
//

import Foundation

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
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getFeedGenerators") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems += uris.map { ("feeds", $0) }

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
                decodeTo: AppBskyLexicon.Feed.GetFeedGeneratorsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
