//
//  ChatBskyGroupCreateGroupMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBlueskyChat {

    /// Creates a group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Creates a group convo, specifying the
    /// members to be added to it. Unlike getConvoForMembers, this isn't idempotent. It will create
    /// new groups even if the membership is identical to pre-existing groups. Will create 'request'
    /// membership for all members, except the owner who is 'accepted'."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.createGroup`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/createGroup.json
    ///
    /// - Parameters:
    ///   - name: The name of the group conversation. Current maximum length is 50 characters.
    ///   - memberDIDs: An array of decentralized identifiers (DIDs) of the members to add. Current
    ///   maximum length is 10,000 items.
    /// - Returns: The group conversation the user account has successfully created.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func createGroup(
        name: String,
        memberDIDs: [String]
    ) async throws -> ChatBskyLexicon.Group.CreateGroupOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.group.createGroup") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Group.CreateGroupRequestBody(
            memberDIDs: memberDIDs,
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
                decodeTo: ChatBskyLexicon.Group.CreateGroupOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
