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
    /// - Returns: A `Result`, containing either a
    /// ``ChatBskyLexicon/Conversation/LeaveConversationOutput``
    /// if successful, or an `Error` if not.
    public func leaveConversation(from conversationID: String) async throws -> Result<ChatBskyLexicon.Conversation.LeaveConversationOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.convo.leaveConvo") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let requestBody = ChatBskyLexicon.Conversation.LeaveConversationRequestBody(
            conversationID: conversationID
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: requestBody,
                                                                  decodeTo: ChatBskyLexicon.Conversation.LeaveConversationOutput.self)

            return .success(response)
        } catch {
            throw error
        }
    }
}
