//
//  ChatGetActorMetadata.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Retrieves the user account's metadata as a moderator.
    /// 
    /// - Important: This is a moderator task and as such, regular users won't be able to access
    /// this; if they attempt to do so, an error will occur.
    /// 
    /// - SeeAlso: This is based on the [`chat.bsky.moderation.getActorMetadata`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/moderation/getActorMetadata.json
    /// 
    /// - Parameter actorDID: The decentralized identifier (DID) of the user account.
    /// - Returns: The metadata of the specified user account's chat account, which contains the
    /// number of messages sent and received, number of total conversations, and number of
    /// started conversations. The metadata is avaialble for the past 7 days, the past 30 days,
    /// and the lifetime of the chat account.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getMessageContext(actorDID: String) async throws -> ChatBskyLexicon.Moderation.GetActorMetadataOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.moderation.getActorMetadata") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("actor", actorDID))

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = await APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)",
                isRelatedToBskyChat: true
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ChatBskyLexicon.Moderation.GetActorMetadataOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
