//
//  ChatGetMessageContext.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Retrieves the message context as a moderator.
    /// 
    /// - Important: This is a moderator task and as such, regular users won't be able to access
    /// this; if they attempt to do so, an error will occur.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.moderation.getMessageContext`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/moderation/getMessageContext.json
    /// 
    /// - Parameters:
    ///   - conversationID: The ID of the conversation. Optional.
    ///   - messageID: The ID of the message.
    ///   - messagesBefore: The number of messages older than the message in `messageID`. Optional.
    ///   Defaults to `5`.
    ///   - messagesAfter: The number of messages younger than the message in `messageID`.
    ///   Optional. Defaults to `5`.
    /// - Returns: A `Result`, containing either a ``ChatBskyLexicon/Moderation/GetMessageContextOutput``
    /// if successful, or an `Error` if not.
    public func getMessageContext(
        from conversationID: String?,
        messageID: String,
        messagesBefore: Int? = 5,
        messagesAfter: Int? = 5
    ) async throws -> Result<ChatBskyLexicon.Moderation.GetMessageContextOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.moderation.getMessageContext") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        if let conversationID {
            queryItems.append(("convoId", conversationID))
        }

        queryItems.append(("messageId", messageID))

        if let messagesBefore {
            queryItems.append(("before", "\(messagesBefore)"))
        }

        if let messagesAfter {
            queryItems.append(("after", "\(messagesAfter)"))
        }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: ChatBskyLexicon.Moderation.GetMessageContextOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
