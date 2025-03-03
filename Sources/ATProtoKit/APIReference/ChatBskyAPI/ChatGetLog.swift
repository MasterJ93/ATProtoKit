//
//  ChatGetLog.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Retrieves logs for messages.
    /// 
    /// - SeeAlso: This is based on the [`chat.bsky.convo.getLog`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/getLog.json
    /// 
    /// - Parameter cursor: The mark used to indicate the starting point for the next set of
    ///   result. Optional.
    /// - Returns: An array of message logs, with an optional cursor to expand the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getLog(cursor: String? = nil) async throws -> ChatBskyLexicon.Conversation.GetLogOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.serviceEndpoint,
              let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.convo.getLog") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

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
                labelersValue: "did:plc:ar7c4by46qjdydhdevvrndac#atproto_labeler",
                isRelatedToBskyChat: true
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ChatBskyLexicon.Conversation.GetLogOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
