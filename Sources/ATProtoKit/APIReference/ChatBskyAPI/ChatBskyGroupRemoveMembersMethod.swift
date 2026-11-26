//
//  ChatBskyGroupRemoveMembersMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBlueskyChat {

    /// Removes members from a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Removes members from a group. This
    /// deletes convo memberships, doesn't just set a status."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.removeMembers`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/removeMembers.json
    ///
    /// - Parameters:
    ///   - conversationID: The ID of the conversation.
    ///   - memberDIDs: An array of decentralized identifiers (DIDs) of the members to remove.
    /// - Returns: The group conversation the user account has successfully removed members from.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func removeMembers(
        from conversationID: String,
        memberDIDs: [String]
    ) async throws -> ChatBskyLexicon.Group.RemoveMembersOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.group.removeMembers") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Group.RemoveMembersRequestBody(
            conversationID: conversationID,
            memberDIDs: memberDIDs
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
                decodeTo: ChatBskyLexicon.Group.RemoveMembersOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
