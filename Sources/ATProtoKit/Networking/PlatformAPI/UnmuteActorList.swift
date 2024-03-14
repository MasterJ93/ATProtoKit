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
    /// - Parameter listURI: The URI of a list.
    public func unmuteActorList(_ listURI: String) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.unmuteActorList") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let requestBody = GraphUnmuteActorList(listURI: listURI)

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(session.accessToken)")

            let response = try await APIClientService.sendRequest(request)
        } catch {
            throw error
        }
    }
}
