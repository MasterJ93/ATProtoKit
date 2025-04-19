//
//  ChatDeleteMessageForSelf.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Deletes a mesage only from the user account's end.
    /// 
    /// - SeeAlso: This is based on the [`chat.bsky.convo.deleteMessageForSelf`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/deleteMessageForSelf.json
    /// 
    /// - Parameters:
    ///   - conversationID: The ID of the conversation.
    ///   - messageID: The ID of the message.
    /// - Returns: A deleted message view.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func deleteMessageForSelf(
        conversationID: String,
        messageID: String
    ) async throws -> ChatBskyLexicon.Conversation.DeletedMessageViewDefinition {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.convo.deleteMessageForSelf") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Conversation.DeleteMessageForSelfRequestBody(
            conversationID: conversationID,
            messageID: messageID
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
                decodeTo: ChatBskyLexicon.Conversation.DeletedMessageViewDefinition.self
            )

            return response
        } catch {
            throw error
        }
    }
}
