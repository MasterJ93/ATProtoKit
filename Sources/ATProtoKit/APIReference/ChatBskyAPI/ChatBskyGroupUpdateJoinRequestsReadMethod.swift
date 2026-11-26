//
//  ChatBskyGroupUpdateJoinRequestsReadMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBlueskyChat {

    /// Marks all requests to join a group conversation as read.
    ///
    /// - Note: According to the AT Protocol specifications: "Marks all join requests as read for
    /// the group owner."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.updateJoinRequestsRead`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/updateJoinRequestsRead.json
    ///
    /// - Parameter conversationID: The ID of the conversation.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func updateJoinRequestsRead(for conversationID: String) async throws {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.group.updateJoinRequestsRead") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Group.UpdateJoinRequestsReadRequestBody(
            conversationID: conversationID
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: nil,
                contentTypeValue: "application/json",
                requiresAuthorization: true,
                isRelatedToBskyChat: true
            )

            _ = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
