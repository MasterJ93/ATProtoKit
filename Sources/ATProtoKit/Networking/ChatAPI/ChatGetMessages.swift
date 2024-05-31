//
//  ChatGetMessages.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Retrieves messages from a conversation.
    /// 
    /// - SeeAlso: This is based on the [`chat.bsky.convo.getMessages`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/getMessages.json
    /// 
    /// - Parameters:
    ///   - conversationID: The ID of the conversation.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `50`.
    /// - Returns: A `Result`, containing either a ``ChatBskyLexicon/Conversation/GetMessagesOutput``
    /// if successful, or an `Error` if not.
    public func getMessages(
        from conversationID: String,
        limit: Int? = 50
    ) async throws -> Result<ChatBskyLexicon.Conversation.GetMessagesOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.convo.getMessages") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        queryItems.append(("convoId", conversationID))

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
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
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: ChatBskyLexicon.Conversation.GetMessagesOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
