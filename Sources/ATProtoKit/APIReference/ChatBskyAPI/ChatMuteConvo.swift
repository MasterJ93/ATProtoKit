//
//  ChatMuteConvo.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Mutes a conversation the user account is participating in.
    /// 
    /// - SeeAlso: This is based on the [`chat.bsky.convo.muteConvo`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/muteConvo.json
    /// 
    /// - Parameter conversationID: The ID of the conversation.
    /// - Returns: The conversation that the user account has successfully muted.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func muteConversation(from conversationID: String) async throws -> ChatBskyLexicon.Conversation.MuteConversationOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.convo.muteConvo") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Conversation.MuteConversationRequestBody(
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
                                                                  decodeTo: ChatBskyLexicon.Conversation.MuteConversationOutput.self)

            return response
        } catch {
            throw error
        }
    }
}
