//
//  GetPopularFeedGenerators.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-17.
//

import Foundation

extension ATProtoKit {
    /// Retrieves an array of globally popular feed generators.
    /// 
    /// - Important: This is an unspecced method, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "An unspecced view of globally popular
    /// feed generators."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getPopularFeedGenerators`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getPopularFeedGenerators.json
    ///
    /// - Parameters:
    ///   - query: The string used to 
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   result. Optional.
    /// - Returns: A `Result`, containing either an ``UnspeccedGetPopularFeedGeneratorsOutput``
    /// if successful, or an `Error` if not.
    public func getPopularFeedGenerators(_ query: String?, limit: Int? = 50,
                                         cursor: String? = nil) async throws -> Result<UnspeccedGetPopularFeedGeneratorsOutput, Error> {
        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getPopularFeedGenerators") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        if let query {
            queryItems.append(("query", query))
        }

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
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: UnspeccedGetPopularFeedGeneratorsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
