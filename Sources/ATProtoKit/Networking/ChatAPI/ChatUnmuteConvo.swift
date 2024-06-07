//
//  ChatUnmuteConvo.swift
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
    /// - Parameter conversationID: The ID of the conversation.
    /// - Returns: A `Result`, containing either a
    /// ``ChatBskyLexicon/Conversation/UnmuteConversationOutput``
    /// if successful, or an `Error` if not.
    public func unmuteConversation(from conversationID: String) async throws -> Result<ChatBskyLexicon.Conversation.UnmuteConversationOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.convo.unmuteConvo") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let requestBody = ChatBskyLexicon.Conversation.UnMuteConversationRequestBody(
            conversationID: conversationID
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(accessToken)",
                                                         isRelatedToBskyChat: true)
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: requestBody,
                                                                  decodeTo: ChatBskyLexicon.Conversation.UnmuteConversationOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
