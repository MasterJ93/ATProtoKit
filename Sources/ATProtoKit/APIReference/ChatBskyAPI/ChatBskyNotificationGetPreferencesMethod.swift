//
//  ChatBskyNotificationGetPreferencesMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-12.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBlueskyChat {

    /// Gets chat notification preferences for a user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Get the requesting account's chat
    /// notification preferences. Defaults are returned for accounts that have not set any
    /// preferences. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.notification.getPreferences`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/notification/getPreferences.json
    ///
    /// - Returns: The chat notification preferences for the user account.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getChatNotificationPreferences() async throws -> ChatBskyLexicon.Notification.GetPreferencesOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.notification.getPreferences") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                requiresAuthorization: true,
                isRelatedToBskyChat: true
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ChatBskyLexicon.Notification.GetPreferencesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
