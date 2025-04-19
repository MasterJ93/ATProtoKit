//
//  GetPreferences.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-18.
//

import Foundation

extension ATProtoKit {

    /// Receive the preferences of a given user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Get private preferences attached
    /// to the current account. Expected use is synchronization between multiple devices, and
    /// import/export during account migration. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.getPreferences`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getPreferences.json
    ///
    /// - Returns: An array, containing the preferences set in the user account.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getPreferences() async throws -> AppBskyLexicon.Actor.GetPreferencesOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.actor.getPreferences") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = await APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Actor.GetPreferencesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
