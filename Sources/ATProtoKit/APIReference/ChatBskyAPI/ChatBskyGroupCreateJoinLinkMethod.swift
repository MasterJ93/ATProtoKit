//
//  ChatBskyGroupCreateJoinLinkMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBlueskyChat {

    /// Creates a join link for a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Creates a join link for the group
    /// convo."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.createJoinLink`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/createJoinLink.json
    ///
    /// - Parameters:
    ///   - conversationID: The ID of the conversation.
    ///   - isApprovalRequired: Indicates whether joining through the join link requires approval.
    ///   Optional. Defaults to `false`.
    ///   - joinRule: The rule for joining the group conversation.
    /// - Returns: The join link the user account has successfully created.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func createJoinLink(
        for conversationID: String,
        isApprovalRequired: Bool? = false,
        joinRule: ChatBskyLexicon.Group.JoinRuleDefinition
    ) async throws -> ChatBskyLexicon.Group.CreateJoinLinkOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.group.createJoinLink") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Group.CreateJoinLinkRequestBody(
            conversationID: conversationID,
            isApprovalRequired: isApprovalRequired,
            joinRule: joinRule
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
                decodeTo: ChatBskyLexicon.Group.CreateJoinLinkOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
