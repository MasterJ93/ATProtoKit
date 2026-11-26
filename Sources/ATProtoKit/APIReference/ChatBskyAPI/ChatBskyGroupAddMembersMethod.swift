//
//  ChatBskyGroupAddMembersMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBlueskyChat {

    /// Adds members to a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Adds members to a group. The members
    /// are added in 'request' status, so they have to accept it. This creates convo memberships."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.addMembers`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/addMembers.json
    ///
    /// - Parameters:
    ///   - conversationID: The ID of the conversation.
    ///   - memberDIDs: An array of decentralized identifiers (DIDs) of the members to add.
    /// - Returns: The group conversation the user account has successfully added members to, with
    /// an optional array of the members that were added.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func addMembers(
        to conversationID: String,
        memberDIDs: [String]
    ) async throws -> ChatBskyLexicon.Group.AddMembersOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.group.addMembers") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Group.AddMembersRequestBody(
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
                decodeTo: ChatBskyLexicon.Group.AddMembersOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
