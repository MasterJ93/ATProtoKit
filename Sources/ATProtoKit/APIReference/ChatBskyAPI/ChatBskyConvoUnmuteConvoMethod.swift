//
//  ChatBskyConvoUnmuteConvoMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Unmutes a conversation the user account is participating in.
    /// 
    /// - SeeAlso: This is based on the [`chat.bsky.convo.unmuteConvo`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/unmuteConvo.json
    /// 
    /// - Parameter id: The ID of the conversation.
    /// - Returns: The conversation that the user account has successfully unmuted.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func unmuteConversation(by id: String) async throws -> ChatBskyLexicon.Conversation.UnmuteConversationOutput {
        guard let _ = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
//        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(APIHostname.bskyChat)/xrpc/chat.bsky.convo.unmuteConvo") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Conversation.UnMuteConversationRequestBody(
            conversationID: id
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)",
                isRelatedToBskyChat: true
            )
            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ChatBskyLexicon.Conversation.UnmuteConversationOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
