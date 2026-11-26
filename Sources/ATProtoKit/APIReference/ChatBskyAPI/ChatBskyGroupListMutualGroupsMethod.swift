//
//  ChatBskyGroupListMutualGroupsMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBlueskyChat {

    /// Lists the group conversations that both the user account and the specified user account are
    /// members of.
    ///
    /// - Note: According to the AT Protocol specifications: "Returns a page of group conversations
    /// that both the requester and the specified actor are members of."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.listMutualGroups`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/listMutualGroups.json
    ///
    /// - Parameters:
    ///   - subjectDID: The decentralized identifier (DID) of the user account.
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of results.
    ///   Optional.
    /// - Returns: An array of mutual group conversations, with an optional cursor for expanding the
    /// array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func listMutualGroups(
        with subjectDID: String,
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> ChatBskyLexicon.Group.ListMutualGroupsOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.group.listMutualGroups") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("subject", subjectDID))

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                requiresAuthorization: true,
                isRelatedToBskyChat: true
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ChatBskyLexicon.Group.ListMutualGroupsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
