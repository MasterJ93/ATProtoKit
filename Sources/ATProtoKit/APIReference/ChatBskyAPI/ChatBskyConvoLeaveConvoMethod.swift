//
//  ChatBskyConvoLeaveConvoMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBlueskyChat {

    /// Removes the user account from the conversation.
    /// 
    /// - SeeAlso: This is based on the [`chat.bsky.convo.leaveConvo`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/leaveConvo.json
    /// 
    /// - Parameter id: The ID of the conversation.
    /// - Returns: The ID and revision of the conversation that the user account has left.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func leaveConversation(from id: String) async throws -> ChatBskyLexicon.Conversation.LeaveConversationOutput {
        guard let _ = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
//        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(APIHostname.bskyChat)/xrpc/chat.bsky.convo.leaveConvo") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Conversation.LeaveConversationRequestBody(
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
                decodeTo: ChatBskyLexicon.Conversation.LeaveConversationOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
