//
//  GetConversationAvailability.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-02-21.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Checks if the requester and other members can chat.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get whether the requester and the
    /// other members can chat. If an existing convo is found for these members, it is returned."
    /// 
    /// - SeeAlso: This is based on the [`chat.bsky.convo.getConvoAvailability`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/getConvoAvailability.json
    /// 
    /// - Parameter members: An array of members in the conversation. Can only handle up to
    /// 10 items.
    /// - Returns: The conversation itself, as well as an indication of whether the requester and
    /// other members can chat.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getConversationAvailability(members: [String]) async throws -> ChatBskyLexicon.Conversation.GetConversationAvailabilityOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.convo.getConvoAvailability") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        let cappedMembersArray = members.prefix(10)
        queryItems += cappedMembersArray.map { ("members", $0) }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)",
                isRelatedToBskyChat: true
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ChatBskyLexicon.Conversation.GetConversationAvailabilityOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
