//
//  UpdateAllRead.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-24.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Marks all conversations as read.
    /// 
    /// - SeeAlso: This is based on the [`chat.bsky.convo.updateAllRead`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/updateAllRead.json
    /// 
    /// - Parameter status: The status of the conversation. Optional.
    /// - Returns: An updated count of conversations.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func updateAllRead(
        status: ChatBskyLexicon.Conversation.UpdateAllRead.Status? = nil
    ) async throws -> ChatBskyLexicon.Conversation.UpdateAllReadOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.convo.updateAllRead") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Conversation.UpdateAllReadRequestBody(
            status: status
        )

        do {
            let request = await APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)",
                isRelatedToBskyChat: true
            )

            let response = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ChatBskyLexicon.Conversation.UpdateAllReadOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
