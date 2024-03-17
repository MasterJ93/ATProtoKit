//
//  PutPreferences.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-23.
//

import Foundation

extension ATProtoKit {
    /// Edits the preferences for the user.
    /// 
    /// - Parameter preferences: An array of preferences the user wants to change.
    public func putPreferences(preferences: ActorPreferences) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.actor.putPreferences") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let requestBody = ActorPutPreferences(preferences: preferences.preferences)

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         authorizationValue: "Bearer \(session.accessToken)")

            try await APIClientService.sendRequest(request, withEncodingBody: requestBody)
        } catch {
            throw ATURIError.invalidFormat
        }
    }
}
