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
    /// - Returns: A `Result`, containing either a ``ChatBskyLexicon/Conversation/MuteConversationOutput``
    /// if successful, or an `Error` if not.
    public func muteConversation(from conversationID: String) async throws -> Result<ChatBskyLexicon.Conversation.MuteConversationOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.convo.muteConvo") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let requestBody = ChatBskyLexicon.Conversation.MuteConversationRequestBody(
            conversationID: conversationID
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: requestBody,
                                                                  decodeTo: ChatBskyLexicon.Conversation.MuteConversationOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
