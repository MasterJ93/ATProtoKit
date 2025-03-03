//
//  ChatSendMessageBatch.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Sends a batch of messages to the conversation.
    /// 
    /// Due to Bluesky limitations, you are unable to send images at this time.
    /// 
    /// - SeeAlso: This is based on the [`chat.bsky.convo.sendMessageBatch`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/sendMessageBatch.json
    /// 
    /// - Parameter messages: A array of messages. Current maximum length is 100 items.
    /// - Returns: An array of messages.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func sendMessageBatch(
        _ messages: [ChatBskyLexicon.Conversation.SendMessageBatch.BatchItem]
    ) async throws -> ChatBskyLexicon.Conversation.SendMessageBatchOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.serviceEndpoint,
              let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.convo.sendMessageBatch") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Conversation.SendMessageBatchRequestBody(
            items: messages
        )

        do {
            let request = APIClientService.createRequest(
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
                decodeTo: ChatBskyLexicon.Conversation.SendMessageBatchOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
