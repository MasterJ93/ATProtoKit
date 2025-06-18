//
//  AppBskyNotificationGetPreferencesMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-06-14.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Gets notification preferences for a user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Get notification-related preferences for
    /// an account. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.getPreferences`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/getPreferences.json
    ///
    /// - Returns: A list of preferences.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getNotificationPreferences() async throws -> AppBskyLexicon.Notification.GetPreferencesOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.notification.getPreferences") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Notification.GetPreferencesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
