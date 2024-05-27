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
    /// - Note: According to the AT Protocol specifications: "Set the private preferences
    /// attached to the account."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.putPreferences`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/putPreferences.json
    ///
    /// - Parameter preferences: An array of preferences the user wants to change.
    public func putPreferences(preferences: ActorPreferences) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.actor.putPreferences") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ActorPutPreferences(
            preferences: preferences.preferences
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: nil,
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")

            try await APIClientService.sendRequest(request,
                                                   withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
