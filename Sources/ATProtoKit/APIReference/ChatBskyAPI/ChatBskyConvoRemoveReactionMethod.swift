//
//  ChatBskyConvoRemoveReactionMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-16.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Removes an emoji in a message as a reaction.
    ///
    /// - Note: According to the AT Protocol specifications: "Removes an emoji reaction from a message.
    /// Requires authentication. It is idempotent, so multiple calls from the same user with the same emoji
    /// result in that reaction not being present, even if it already wasn't."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.removeReaction`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/removeReaction.json
    ///
    /// - Parameters:
    ///   - conversationID: The ID of the conversation.
    ///   - messageID: The ID of the message.
    ///   - value: The value of the reaction.
    /// - Returns: The message the reaction is attached to.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func removeReaction(
        to conversationID: String,
        for messageID: String,
        value: String
    ) async throws -> ChatBskyLexicon.Conversation.RemoveReactionOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.convo.removeReaction") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Conversation.RemoveReactionRequestBody(
            conversationID: conversationID,
            messageID: messageID,
            value: value
        )

        do {
            let request = await APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)",
                isRelatedToBskyChat: true
            )

            let response = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ChatBskyLexicon.Conversation.RemoveReactionOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
