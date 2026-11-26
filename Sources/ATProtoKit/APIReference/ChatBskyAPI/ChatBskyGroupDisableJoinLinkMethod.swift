//
//  ChatBskyGroupDisableJoinLinkMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBlueskyChat {

    /// Disables the join link of a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Disables the active join link for the
    /// group convo."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.disableJoinLink`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/disableJoinLink.json
    ///
    /// - Parameter conversationID: The ID of the conversation.
    /// - Returns: The join link the user account has successfully disabled.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func disableJoinLink(for conversationID: String) async throws -> ChatBskyLexicon.Group.DisableJoinLinkOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.group.disableJoinLink") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Group.DisableJoinLinkRequestBody(
            conversationID: conversationID
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
                decodeTo: ChatBskyLexicon.Group.DisableJoinLinkOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
