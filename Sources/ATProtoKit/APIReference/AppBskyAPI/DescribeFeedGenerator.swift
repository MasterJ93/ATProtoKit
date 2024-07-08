//
//  DescribeFeedGenerator.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-04.
//

import Foundation

extension ATProtoKit {

    /// Gets information about a given feed generator.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get information about a
    /// feed generator, including policies and offered feed URIs. Does not require auth;
    /// implemented by Feed Generator services (not App View)."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.describeFeedGenerator`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/describeFeedGenerator.json
    ///
    /// - Returns:The details of a feed generator, including its decentralized identifier (DID),
    /// feed URIs, and policy information.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func describeFeedGenerator(pdsURL: String? = nil) async throws -> AppBskyLexicon.Feed.DescribeFeedGeneratorOutput {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/app.bsky.feed.describeFeedGenerator") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         acceptValue: nil,
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: AppBskyLexicon.Feed.DescribeFeedGeneratorOutput.self)

            return response
        } catch {
            throw error
        }
    }
}
