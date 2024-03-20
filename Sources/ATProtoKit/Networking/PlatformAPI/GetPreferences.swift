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
    /// - Note: According to the AT Protocol specifications: "Get private preferences attached to the current account. Expected use is synchronization between multiple devices, and import/export during
    /// account migration. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.getPreferences`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getPreferences.json
    ///
    /// - Returns: A `Result`, containing either `ActorPreferences` if successful, or `Error` if not.
    public func getPreferences() async throws -> Result<ActorPreferences, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.actor.getPreferences") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request, decodeTo: ActorPreferences.self)

            return .success(response)
        } catch(let error) {
            return .failure(error)
        }
    }
}
