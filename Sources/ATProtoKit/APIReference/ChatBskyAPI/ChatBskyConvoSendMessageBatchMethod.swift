//
//  ChatBskyConvoSendMessageBatchMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
        guard let _ = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
//        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(APIHostname.bskyChat)/xrpc/chat.bsky.convo.sendMessageBatch") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Conversation.SendMessageBatchRequestBody(
            items: messages
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
                decodeTo: ChatBskyLexicon.Conversation.SendMessageBatchOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
