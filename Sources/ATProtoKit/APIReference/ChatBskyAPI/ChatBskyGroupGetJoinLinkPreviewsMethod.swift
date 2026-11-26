//
//  ChatBskyGroupGetJoinLinkPreviewsMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBlueskyChat {

    /// Retrieves the previews of join links.
    ///
    /// - Note: According to the AT Protocol specifications: "Get public information about groups
    /// from join links. The output array matches the input codes one-to-one by position (and each
    /// view also carries its 'code'). Disabled codes return a disabledJoinLinkPreviewView, and
    /// codes that do not map to a previewable link return an invalidJoinLinkPreviewView."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.getJoinLinkPreviews`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/getJoinLinkPreviews.json
    ///
    /// - Parameter codes: An array of join link codes. Current maximum length is 50 items.
    /// - Returns: An array of join link previews, matching the order of the join link codes.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getJoinLinkPreviews(for codes: [String]) async throws -> ChatBskyLexicon.Group.GetJoinLinkPreviewsOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.group.getJoinLinkPreviews") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        let cappedCodesArray = codes.prefix(50)
        queryItems += cappedCodesArray.map { ("codes", $0) }

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
                decodeTo: ChatBskyLexicon.Group.GetJoinLinkPreviewsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
