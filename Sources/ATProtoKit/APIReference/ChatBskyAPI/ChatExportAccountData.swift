//
//  ChatExportAccountData.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Exports the user's account data.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.actor.exportAccountData`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/actor/exportAccountData.json
    ///
    ///- Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func exportAccountData() async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.actor.exportAccountData") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/jsonl",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)",
                                                         isRelatedToBskyChat: true)

            _ = try await APIClientService.sendRequest(request)
        } catch {
            throw error
        }
    }
}
