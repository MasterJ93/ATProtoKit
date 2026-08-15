//
//  AppBskyGraphGetStarterPacksWithMembershipMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-10.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Enumerates starter packs created by the session user that includes membership information
    /// about the specified `actor`.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates the starter packs created
    /// by the session user, and includes membership information about `actor` in those starter
    /// packs. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getStarterPacksWithMembership`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getStarterPacksWithMembership.json
    ///
    /// - Parameters:
    ///   - actor: The user account to check membership for in the session user's starter packs.
    ///   - limit: The number of results to return. Optional. Defaults to `50`.
    ///   Can only choose between `1` and `100`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of starter packs with memberships.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getStarterPacksWithMembership(
        by actor: String,
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> AppBskyLexicon.Graph.GetStarterPacksWithMembershipOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.getStarterPacksWithMembership") else {
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
                requiresAuthorization: true
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Graph.GetStarterPacksWithMembershipOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
