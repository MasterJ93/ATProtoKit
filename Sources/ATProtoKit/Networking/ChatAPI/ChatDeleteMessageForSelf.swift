//
//  ChatDeleteMessageForSelf.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Deletes a mesage only from the user account's end.
    /// 
    /// - SeeAlso: This is based on the [`chat.bsky.convo.deleteMessageForSelf`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/deleteMessageForSelf.json
    /// 
    /// - Parameters:
    ///   - conversationID: The ID of the conversation.
    ///   - messageID: The ID of the message.
    /// /// - Returns: A `Result`, containing either a ``ChatBskyLexicon/Conversation/DeletedMessageViewDefinition``
    /// if successful, or an `Error` if not.
    public func deleteMessageForSelf(
        conversationID: String,
        messageID: String
    ) async throws -> Result<ChatBskyLexicon.Conversation.DeletedMessageViewDefinition, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.convo.deleteMessageForSelf") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let requestBody = ChatBskyLexicon.Conversation.DeleteMessageForSelfRequestBody(
            conversationID: conversationID,
            messageID: messageID
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: requestBody,
                                                                  decodeTo: ChatBskyLexicon.Conversation.DeletedMessageViewDefinition.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
