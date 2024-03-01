//
//  GetPreferences.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-18.
//

import Foundation

extension ATProtoKit {
    /// Receive the preferences of a given user.
    /// 
    /// - Returns: A `Result`, containing either `ActorPreferences` if successful, or `Error` if not.
    public func getPreferences() async throws -> Result<ActorPreferences, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.actor.getPreferences") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .get, acceptValue: "application/json", contentTypeValue: nil, authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, decodeTo: ActorPreferences.self)

            return .success(response)
        } catch(let error) {
            return .failure(error)
        }
    }
}
