//
//  ChatBskyConvoGetConvoMembersMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBlueskyChat {

    /// Retrieves the members of a conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Returns a paginated list of members
    /// from a conversation."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.getConvoMembers`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/convo/getConvoMembers.json
    ///
    /// - Parameters:
    ///   - conversationID: The ID of the conversation.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of members in the conversation, with an optional cursor for expanding
    /// the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getConversationMembers(
        from conversationID: String,
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> ChatBskyLexicon.Conversation.GetConversationMembersOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.convo.getConvoMembers") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("convoId", conversationID))

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                requiresAuthorization: true,
                isRelatedToBskyChat: true
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ChatBskyLexicon.Conversation.GetConversationMembersOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
