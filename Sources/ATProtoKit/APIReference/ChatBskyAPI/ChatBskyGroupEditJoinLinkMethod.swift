//
//  ChatBskyGroupEditJoinLinkMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBlueskyChat {

    /// Edits the join link of a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Edits the existing join link settings
    /// for the group convo."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.editJoinLink`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/editJoinLink.json
    ///
    /// - Parameters:
    ///   - conversationID: The ID of the conversation.
    ///   - isApprovalRequired: Indicates whether joining through the join link requires approval.
    ///   Optional.
    ///   - joinRule: The rule for joining the group conversation. Optional.
    /// - Returns: The join link the user account has successfully edited.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func editJoinLink(
        for conversationID: String,
        isApprovalRequired: Bool? = nil,
        joinRule: ChatBskyLexicon.Group.JoinRuleDefinition? = nil
    ) async throws -> ChatBskyLexicon.Group.EditJoinLinkOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.group.editJoinLink") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Group.EditJoinLinkRequestBody(
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
                decodeTo: ChatBskyLexicon.Group.EditJoinLinkOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
