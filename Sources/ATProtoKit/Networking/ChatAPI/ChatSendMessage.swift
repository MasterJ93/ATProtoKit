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
    /// - Returns: A `Result`, containing either a
    /// ``ChatBskyLexicon/Conversation/MessageViewDefinition``
    /// if successful, or an `Error` if not.
    public func sendMessage(
        conversationID: String,
        message: ChatBskyLexicon.Conversation.MessageInputDefinition
    ) async throws -> Result<ChatBskyLexicon.Conversation.MessageViewDefinition, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.convo.sendMessage") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let requestBody = ChatBskyLexicon.Conversation.SendMessageRequestBody(
            conversationID: conversationID,
            message: message
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: requestBody,
                                                                  decodeTo: ChatBskyLexicon.Conversation.MessageViewDefinition.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
