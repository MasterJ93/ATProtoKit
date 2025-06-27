//
//  AppBskyNotificationPutActivitySubscriptionMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-06-27.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Adds an activity subscription entry.
    ///
    /// - Note: According to the AT Protocol specifications: "Puts an activity subscription entry. The key
    /// should be omitted for creation and provided for updates. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.putActivitySubscription`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/putActivitySubscription.json
    ///
    /// - Parameters:
    ///   - subjectDID: The decentralized identifier (DID) of the user account being subscribed to.
    ///   - activitySubscription: The activity subscription of the specificed user account.
    /// - Returns: The decentralized identifier (DID) of the now-subscribed user account, with the optional
    /// activity subscription.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func putActivitySubscription(
        subjectDID: String,
        activitySubscription: AppBskyLexicon.Notification.ActivitySubscriptionDefinition
    ) async throws -> AppBskyLexicon.Notification.PutActivitySubscriptionOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.notification.putActivitySubscription") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AppBskyLexicon.Notification.PutActivitySubscriptionRequestBody(
            subjectDID: subjectDID,
            activitySubscription: activitySubscription
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: nil,
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: AppBskyLexicon.Notification.PutActivitySubscriptionOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
