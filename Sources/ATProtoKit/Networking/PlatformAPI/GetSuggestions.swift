//
//  GetSuggestions.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-20.
//

import Foundation

extension ATProtoKit {

    /// Gets a list of suggested users.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get a list of suggested actors.
    /// Expected use is discovery of accounts to follow during new account onboarding."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.getSuggestions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getSuggestions.json
    ///
    /// - Parameters:
    ///   - limit: The number of suggested users to follow. Optional. Defaults to 50.
    ///   Can only choose between 1 and 100.
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   results. Optional.
    /// - Returns: A `Result`, containing either an ``AppBskyLexicon/Actor/GetSuggestionsOutput``
    /// if succesful, or an `Error` if it's not.
    public func getSuggestions(
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> Result<AppBskyLexicon.Actor.GetSuggestionsOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.actor.getSuggestions") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        // Make sure limit is between 1 and 100.
        let finalLimit = max(1, min(limit ?? 50, 100))
        var queryItems = [("limit", "\(finalLimit)")]

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: nil,
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: AppBskyLexicon.Actor.GetSuggestionsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
