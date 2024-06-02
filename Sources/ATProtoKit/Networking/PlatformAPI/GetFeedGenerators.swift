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
    /// ``getFeedGenerator(_:)`` instead.
    ///
    /// - Note: According to the AT Protocol specifications: "Get information about a list
    /// of feed generators."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getFeedGenerators`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getFeedGenerators.json
    ///
    /// - Parameter feedURIs: An array of URIs for feed generators.
    /// - Returns: A `Result`, containing either a ``AppBskyLexicon/Feed/GetFeedGeneratorsOutput``
    /// if successful, or an `Error` if not.
    public func getFeedGenerators(_ feedURIs: [String]) async throws -> Result<AppBskyLexicon.Feed.GetFeedGeneratorsOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getFeedGenerators") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        queryItems += feedURIs.map { ("feeds", $0) }

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
                                                                  decodeTo: AppBskyLexicon.Feed.GetFeedGeneratorsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
