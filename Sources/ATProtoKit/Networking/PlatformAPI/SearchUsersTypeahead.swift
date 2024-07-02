//
//  SearchUsersTypeahead.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-23.
//

import Foundation

extension ATProtoKit {

    /// Looks for user profiles (actors) matching the prefixed search term.
    ///
    /// This will search for the display names, descriptions, and handles within the
    /// user profiles.
    ///
    /// - Note: `viewerDID` will be ignored in public or unauthenticated queries.
    ///
    /// - Bug: According to the AT Protocol specifications, this API call does not require
    /// authentication. However, there's an issue where it asks for authentication if there's
    /// no `accessToken`. It's unknown whether this is an issue on the AT Protocol's end or
    /// `AKProtoKit`'s end. For now, use the `shouldAuthenticate` parameter when using
    /// this method.
    ///
    /// - Note: According to the AT Protocol specifications: "Find actor suggestions for a prefix
    /// search term. Expected use is for auto-completion during text field entry. Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.searchActorsTypeahead`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/searchActorsTypeahead.json
    ///
    /// - Parameters:
    ///   - query: The string used against a list of actors.
    ///   - limit: The number of suggested users to follow. Optional. Defaults to `50`. Can only
    ///   choose between `1` and `100`.
    ///   - accessToken: The access token
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    ///   - shouldAuthenticate: Indicates whether the method will use the access token when
    ///   sending the request. Defaults to `false`.
    /// - Returns: An array of actors.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func searchUsersTypeahead(
        by query: String,
        limit: Int? = 10,
        pdsURL: String? = nil,
        shouldAuthenticate: Bool = false
    ) async throws -> AppBskyLexicon.Actor.SearchActorsTypeaheadOutput {
        let authorizationValue = prepareAuthorizationValue(
            methodPDSURL: pdsURL,
            shouldAuthenticate: shouldAuthenticate,
            session: session
        )

        let finalPDSURL = determinePDSURL(customPDSURL: pdsURL)

        guard let requestURL = URL(string: "\(finalPDSURL)/xrpc/app.bsky.actor.searchActorsTypeahead") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("q", query))

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
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
                                                         authorizationValue: authorizationValue)
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: AppBskyLexicon.Actor.SearchActorsTypeaheadOutput.self)

            return response
        } catch {
            throw error
        }
    }
}
