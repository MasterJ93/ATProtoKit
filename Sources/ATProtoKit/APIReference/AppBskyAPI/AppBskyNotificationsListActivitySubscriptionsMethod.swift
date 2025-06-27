//
//  AppBskyNotificationsListActivitySubscriptionsMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-06-27.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Lists all user accounts that the authenticated user account is subscribed to receive
    /// notifications for.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerate all accounts to which the requesting
    /// account is subscribed to receive notifications for. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.listActivitySubscriptions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/listActivitySubscriptions.json
    ///
    /// - Parameters:
    ///   - limit: The number of activity subscriptions to list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of profile views belonging to user account's that the authenticated user account
    /// is subscribed to, with an optional cursor to expand the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func listActivitySubscriptions(
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> AppBskyLexicon.Notification.ListActivitySubscriptionsOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.notification.listActivitySubscriptions") else {
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
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Notification.ListActivitySubscriptionsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
