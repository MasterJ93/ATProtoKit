//
//  ChatSendMessage.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Sends a message to a conversation.
    /// 
    /// Due to current limitations, there is no way to add images to the messages.
    /// 
    /// - SeeAlso: This is based on the [`chat.bsky.convo.sendMessage`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/sendMessage.json
    /// 
    /// - Parameters:
    ///   - conversationID: The ID of the conversation.
    ///   - message: The message to be sent.
    /// - Returns: The message that the user account has successfully sent.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func sendMessage(
        to conversationID: String,
        message: ChatBskyLexicon.Conversation.MessageInputDefinition
    ) async throws -> ChatBskyLexicon.Conversation.MessageViewDefinition {
        guard let _ = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
//        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "https://api.bsky.chat/xrpc/chat.bsky.convo.sendMessage") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Conversation.SendMessageRequestBody(
            conversationID: conversationID,
            message: message
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
                decodeTo: ChatBskyLexicon.Conversation.MessageViewDefinition.self
            )

            return response
        } catch {
            throw error
        }
    }
}
