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
    /// - Parameter pdsURL: The URL of the Personal Data Server (PDS). Optional.
    /// Defaults to `https://api.bsky.app`.
    /// - Returns: An array of suggestions.
    /// 
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getTaggedSuggestions(pdsURL: String = "https://api.bsky.app") async throws -> AppBskyLexicon.Unspecced.GetTaggedSuggestionsOutput {
        guard pdsURL != "" else {
            throw ATRequestPrepareError.emptyPDSURL
        }

        guard let requestURL = URL(string: "\(pdsURL)/xrpc/app.bsky.unspecced.getTaggedSuggestions") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: nil
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Unspecced.GetTaggedSuggestionsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
