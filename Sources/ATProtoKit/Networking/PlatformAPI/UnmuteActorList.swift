//
//  UnmuteActorList.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-10.
//

import Foundation

extension ATProtoKit {

    /// Unmutes a list of user accounts.
    ///
    /// - Note: According to the AT Protocol specifications: "Unmutes the specified list of
    /// accounts. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.unmuteActorList`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/unmuteActorList.json
    ///
    /// - Parameter listURI: The URI of a list.
    public func unmuteActorList(_ listURI: String) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.unmuteActorList") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = GraphUnmuteActorList(
            listURI: listURI
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
