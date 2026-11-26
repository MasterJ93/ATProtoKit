//
//  ChatBskyGroupApproveJoinRequestMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBlueskyChat {

    /// Approves a request to join a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Approves a request to join a group
    /// (via join link) the user owns. Action taken by the group owner."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.approveJoinRequest`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/approveJoinRequest.json
    ///
    /// - Parameters:
    ///   - conversationID: The ID of the conversation.
    ///   - requesterDID: The decentralized identifier (DID) of the user account that requested to
    ///   join.
    /// - Returns: The group conversation the user account has successfully approved the join
    /// request for.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func approveJoinRequest(
        for conversationID: String,
        requesterDID: String
    ) async throws -> ChatBskyLexicon.Group.ApproveJoinRequestOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.group.approveJoinRequest") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Group.ApproveJoinRequestRequestBody(
            conversationID: conversationID,
            memberDID: requesterDID
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
                decodeTo: ChatBskyLexicon.Group.ApproveJoinRequestOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
