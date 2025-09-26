//
//  AppBskyGraphGetListsWithMembershipMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-09-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Enumerates lists created by the session user that includes membership information about the
    /// specified `actor` and supports only curation and moderation lists (not reference lists used in
    /// starter packs).
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates the lists created by the session
    /// user, and includes membership information about `actor` in those lists. Only supports curation and
    /// moderation lists (no reference lists, used in starter packs). Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getListsWithMembership`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getListsWithMembership.json
    ///
    /// - Parameters:
    ///   - actor: The user account that owns the lists.
    ///   - limit: The number of suggested users to follow. Optional. Defaults to 50.
    ///   Can only choose between 1 and 100.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    ///   - purposes: A filter to determine the list's purpose. Optional. Defaults to `nil`.
    /// - Returns: An array of lists with memberships.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getListsWithMembership(
        by actor: String,
        limit: Int? = 50,
        cursor: String? = nil,
        purposes: [AppBskyLexicon.Graph.GetListsWithMembership.Purpose]? = nil
    ) async throws -> AppBskyLexicon.Graph.GetListsWithMembershipOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.getListsWithMembership") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("actor", actor))

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
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Graph.GetListsWithMembershipOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
