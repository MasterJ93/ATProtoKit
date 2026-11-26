//
//  ChatBskyGroupListJoinRequestsMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBlueskyChat {

    /// Lists the requests to join a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Lists a page of request to join a
    /// group (via join link) the user owns. Shows the data from the owner's point of view."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.listJoinRequests`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/listJoinRequests.json
    ///
    /// - Parameters:
    ///   - conversationID: The ID of the conversation.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of results.
    ///   Optional.
    /// - Returns: An array of requests to join the group conversation, with an optional cursor for
    /// expanding the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func listJoinRequests(
        for conversationID: String,
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> ChatBskyLexicon.Group.ListJoinRequestsOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.group.listJoinRequests") else {
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
                decodeTo: ChatBskyLexicon.Group.ListJoinRequestsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
