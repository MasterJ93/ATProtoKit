//
//  ChatBskyGroupRequestJoinMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBlueskyChat {

    /// Requests to join a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Sends a request to join a group (via
    /// join link) to the group owner. Action taken by the prospective group member."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.requestJoin`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/requestJoin.json
    ///
    /// - Parameter code: The code of the join link.
    /// - Returns: The status of the request to join the group conversation, with the group
    /// conversation if the user account has joined it.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func requestJoin(by code: String) async throws -> ChatBskyLexicon.Group.RequestJoinOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.group.requestJoin") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Group.RequestJoinRequestBody(
            code: code
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
                decodeTo: ChatBskyLexicon.Group.RequestJoinOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
