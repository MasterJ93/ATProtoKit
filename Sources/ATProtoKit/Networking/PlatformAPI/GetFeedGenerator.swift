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
    /// ``getFeedGenerators(_:)`` instead.
    ///
    /// - Note: According to the AT Protocol specifications: "Get information about a
    /// feed generator. Implemented by AppView."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getFeedGenerator`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getFeedGenerator.json
    ///
    /// - Parameter feedURI: The URI of the feed generator.
    /// - Returns: A `Result`, containing either a
    /// ``AppBskyLexicon/Feed/GetFeedGeneratorOutput``
    /// if successful, or an `Error` if not.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getFeedGenerator(_ feedURI: String) async throws -> Result<AppBskyLexicon.Feed.GetFeedGeneratorOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getFeedGenerator") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        queryItems.append(("feed", feedURI))

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: AppBskyLexicon.Feed.GetFeedGeneratorOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
