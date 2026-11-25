//
//  ChatBskyConvoUnlockConvoMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBlueskyChat {

    /// Unlocks a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Unlocks a group convo so it is able
    /// to receive new content."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.unlockConvo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/convo/unlockConvo.json
    ///
    /// - Parameter id: The ID of the conversation.
    /// - Returns: The conversation that the user account has successfully unlocked.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func unlockConversation(by id: String) async throws -> ChatBskyLexicon.Conversation.UnlockConversationOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.convo.unlockConvo") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Conversation.UnlockConversationRequestBody(
            conversationID: id
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                requiresAuthorization: true,
                isRelatedToBskyChat: true
            )
            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ChatBskyLexicon.Conversation.UnlockConversationOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
