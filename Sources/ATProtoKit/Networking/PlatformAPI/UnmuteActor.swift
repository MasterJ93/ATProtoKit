//
//  UnmuteActor.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-10.
//

import Foundation

extension ATProtoKit {
    /// Unmutes a user account.
    /// 
    /// - Note: According to the AT Protocol specifications: "Unmutes the specified account. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.unmuteActor`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/unmuteActor.json
    ///
    /// - Parameter actorDID: The decentralized identifier (DID) or handle of a user account.
    public func unmuteActor(_ actorDID: String) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.unmuteActor") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = GraphUnmuteActor(
            actorDID: actorDID
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")

            try await APIClientService.sendRequest(request,
                                                   withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
