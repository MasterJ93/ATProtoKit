//
//  ChatBskyNotificationPutPreferencesMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-12.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBlueskyChat {

    /// Sets chat notification preferences for a user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Set the requesting account's chat
    /// notification preferences. Only the provided preferences are updated; omitted preferences
    /// are left unchanged."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.notification.putPreferences`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/notification/putPreferences.json
    ///
    /// - Parameters:
    ///   - chat: Notification preferences for accepted conversations. Optional.
    ///   - chatRequest: Notification preferences for conversation requests. Optional.
    /// - Returns: The updated chat notification preferences.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func putChatNotificationPreferences(
        chat: ChatBskyLexicon.Notification.ChatPreferenceDefinition? = nil,
        chatRequest: ChatBskyLexicon.Notification.ChatPreferenceDefinition? = nil
    ) async throws -> ChatBskyLexicon.Notification.PutPreferencesOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.notification.putPreferences") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Notification.PutPreferencesRequestBody(
            chat: chat,
            chatRequest: chatRequest
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: nil,
                requiresAuthorization: true,
                isRelatedToBskyChat: true
            )
            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ChatBskyLexicon.Notification.PutPreferencesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
