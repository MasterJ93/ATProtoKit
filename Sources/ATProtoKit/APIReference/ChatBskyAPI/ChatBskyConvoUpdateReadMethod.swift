//
//  ChatBskyConvoUpdateReadMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Updates the conversation to be marked as read.
    /// 
    /// - SeeAlso: This is based on the [`chat.bsky.convo.updateRead`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/updateRead.json
    /// 
    /// - Parameters:
    ///   - conversationID: The ID of the conversation.
    ///   - messageID: The ID of the message. Optional.
    /// - Returns: The conversation that the user account has now marked as unread.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func updateRead(
        from conversationID: String,
        to messageID: String? = nil
    ) async throws -> ChatBskyLexicon.Conversation.UpdateReadOutput {
        guard let _ = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
//        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "https://api.bsky.chat/xrpc/chat.bsky.convo.updateRead") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Conversation.UpdateReadRequestBody(
            conversationID: conversationID,
            messageID: messageID
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)",
                isRelatedToBskyChat: true
            )
            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ChatBskyLexicon.Conversation.UpdateReadOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
