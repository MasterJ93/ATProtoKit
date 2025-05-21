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
    /// - Parameter id: The ID of the conversation.
    /// - Returns: The conversation between tto user accounts that matches `id`.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getConversation(by id: String) async throws -> ChatBskyLexicon.Conversation.GetConversationOutput {
        guard let _ = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
//        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "https://api.bsky.chat/xrpc/chat.bsky.convo.getConvo") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("convoId", id))

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = await APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)",
                isRelatedToBskyChat: true
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ChatBskyLexicon.Conversation.GetConversationOutput.self
            )

            return response
        } catch {
            throw error
        }

    }
}
