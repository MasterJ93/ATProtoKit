//
//  ChatUpdateRead.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Updates the conversation to be marked as read.
    /// 
    /// - SeeAlso: This is based on the [`chat.bsky.convo.updateRead`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/updateRead.json
    /// 
    /// - Parameters:
    ///   - conversationID: The ID of the conversation.
    ///   - messageID: The ID of the message. Optional.
    /// - Returns: A `Result`, containing either a
    /// ``ChatBskyLexicon/Conversation/UpdateReadOutput``
    /// if successful, or an `Error` if not.
    public func updateRead(
        from conversationID: String,
        upTo messageID: String? = nil
    ) async throws -> Result<ChatBskyLexicon.Conversation.UpdateReadOutput, Error> {
            guard session != nil,
                  let accessToken = session?.accessToken else {
                return .failure(ATRequestPrepareError.missingActiveSession)
            }

            guard let sessionURL = session?.pdsURL,
                  let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.convo.updateRead") else {
                return .failure(ATRequestPrepareError.invalidRequestURL)
            }

            let requestBody = ChatBskyLexicon.Conversation.UpdateReadRequestBody(
                conversationID: conversationID,
                messageID: messageID
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
                                                                      decodeTo: ChatBskyLexicon.Conversation.UpdateReadOutput.self)

                return .success(response)
            } catch {
                return .failure(error)
            }
    }
}
