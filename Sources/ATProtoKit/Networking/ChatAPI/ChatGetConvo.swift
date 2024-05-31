//
//  ChatGetConvo.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Retrieves a conversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.getConvo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/getConvo.json
    ///
    /// - Parameter members: An array of members within the conversation. Maximum amount is
    /// 10 items.
    /// - Returns: A `Result`, containing either a ``ChatBskyLexicon/Conversation/GetConversationOutput``
    /// if successful, or an `Error` if not.
    public func getConversation(byID conversationID: String) async throws -> Result<ChatBskyLexicon.Conversation.GetConversationOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.getList") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        queryItems.append(("convoId", conversationID))

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
                                                                  decodeTo: ChatBskyLexicon.Conversation.GetConversationOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }

    }
}
