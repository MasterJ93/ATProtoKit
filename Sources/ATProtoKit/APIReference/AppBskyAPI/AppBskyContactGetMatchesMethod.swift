//
//  AppBskyContactGetMatchesMethod.swift
//  ATProtoKit
//
//  Created by KC-2001MS on 2026-08-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Gets the list of mutually matched contacts.
    ///
    /// - Note: According to the AT Protocol specifications: "Returns the matched contacts
    /// (contacts that were mutually imported). Excludes dismissed matches.
    /// Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.getMatches`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/getMatches.json
    ///
    /// - Parameters:
    ///   - limit: The number of items the list will hold. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: A ``AppBskyLexicon/Contact/GetMatchesOutput`` containing an array of matched
    /// user profiles and an optional cursor.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getMatches(
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> AppBskyLexicon.Contact.GetMatchesOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.contact.getMatches") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

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
                requiresAuthorization: true
            )

            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Contact.GetMatchesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
