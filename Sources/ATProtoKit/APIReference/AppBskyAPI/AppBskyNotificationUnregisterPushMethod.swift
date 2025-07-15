//
//  AppBskyNotificationUnregisterPushMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-07-15.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Unregisters push notifications.
    ///
    /// - Note: According to the AT Protocol specifications: "The inverse of registerPush - inform a
    /// specified service that push notifications should no longer be sent to the given token for the
    /// requesting account. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.unregisterPush`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/unregisterPush.json
    ///
    /// - Parameters:
    ///   - serviceDID: The decentralized identifier (DID) for the push notification request.
    ///   - token: The push notification token.
    ///   - platform: The platform for the push notifications.
    ///   - appID: The app ID for the push notification.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func unregisterPush(
        serviceDID: String,
        token: String,
        platform: AppBskyLexicon.Notification.UnregisterPush.Platform,
        appID: String
    ) async throws {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.notification.unregisterPush") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AppBskyLexicon.Notification.UnregisterPushRequestBody(
            serviceDID: serviceDID,
            token: token,
            platform: platform,
            appID: appID
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )

            _ = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: AppBskyLexicon.Notification.PutPreferencesV2Output.self
            )
        } catch {
            throw error
        }
    }
}
