//
//  ChatBskyGroupEditGroupMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBlueskyChat {

    /// Edits a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Edits group settings."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.editGroup`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/editGroup.json
    ///
    /// - Parameters:
    ///   - conversationID: The ID of the conversation.
    ///   - name: The name of the group conversation. Current maximum length is 50 characters.
    /// - Returns: The group conversation the user account has successfully edited.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func editGroup(
        by conversationID: String,
        name: String
    ) async throws -> ChatBskyLexicon.Group.EditGroupOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.group.editGroup") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Group.EditGroupRequestBody(
            conversationID: conversationID,
            name: name
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
                decodeTo: ChatBskyLexicon.Group.EditGroupOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
