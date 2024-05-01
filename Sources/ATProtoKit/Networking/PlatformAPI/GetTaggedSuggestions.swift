//
//  GetTaggedSuggestions.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-17.
//

import Foundation

extension ATProtoKit {
    /// Retrieves an array of tagged feeds and users.
    /// 
    /// - Important: This is an unspecced method, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of suggestions (feeds and
    /// users) tagged with categories."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getTaggedSuggestions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getTaggedSuggestions.json
    ///
    /// - Returns: A `Result`, containing either an ``UnspeccedGetTaggedSuggestionsOutput``
    /// if successful, or an `Error` if not.
    public func getTaggedSuggestions(pdsURL: String? = nil) async throws -> Result<UnspeccedGetTaggedSuggestionsOutput, Error> {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getTaggedSuggestions") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: UnspeccedGetTaggedSuggestionsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
