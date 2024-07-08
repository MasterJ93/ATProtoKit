//
//  ChatLeaveConvo.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Removes the user account from the conversation.
    /// 
    /// - SeeAlso: This is based on the [`chat.bsky.convo.leaveConvo`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/leaveConvo.json
    /// 
    /// - Parameter conversationID: The ID of the conversation.
    /// - Returns: The ID and revision of the conversation that the user account has left.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func leaveConversation(from conversationID: String) async throws -> ChatBskyLexicon.Conversation.LeaveConversationOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.convo.leaveConvo") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Conversation.LeaveConversationRequestBody(
            conversationID: conversationID
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(accessToken)",
                                                         isRelatedToBskyChat: true)
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: requestBody,
                                                                  decodeTo: ChatBskyLexicon.Conversation.LeaveConversationOutput.self)

            return response
        } catch {
            throw error
        }
    }
}
