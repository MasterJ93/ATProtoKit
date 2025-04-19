//
//  AcceptConversation.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-21.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Accepts a chat conversation.
    /// 
    /// - SeeAlso: This is based on the [`chat.bsky.convo.acceptConvo`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/acceptConvo.json
    /// 
    /// - Parameter id: The ID of the conversation.
    /// - Returns: The revision ID of the accepted conversation.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func acceptConversation(by id: String) async throws -> ChatBskyLexicon.Conversation.AcceptConversationOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.convo.acceptConvo") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Conversation.AcceptConversationRequestBody(
            id: id
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
                decodeTo: ChatBskyLexicon.Conversation.AcceptConversationOutput.self
            )

            return response
        } catch {
            throw error
        }
    }

}
