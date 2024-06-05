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
    /// - Returns: A `Result`, containing either a
    /// ``ChatBskyLexicon/Moderation/GetActorMetadataOutput``
    /// if successful, or an `Error` if not.
    public func getMessageContext(actorDID: String) async throws -> Result<ChatBskyLexicon.Moderation.GetActorMetadataOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.moderation.getActorMetadata") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        queryItems.append(("actor", actorDID))

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: ChatBskyLexicon.Moderation.GetActorMetadataOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
