//
//  RegisterPush.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-20.
//

import Foundation

extension ATProtoKit {

    /// Registers the user to receive push notifications from the server to the client.
    /// 
    /// - Note: According to the AT Protocol specifications: "Register to receive push notifications,
    /// via a specified service, for the requesting account. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.registerPush`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/registerPush.json
    /// 
    /// - Parameters:
    ///   - serviceDID: The decentralized identifier (DID) of the service.
    ///   - token: The token of the service.
    ///   - platform: The platform of the client.
    ///   - appID: The identifier of the client.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func registerPush(
        serviceDID: String,
        token: String,
        platform: AppBskyLexicon.Notification.RegisterPush.Platform,
        appID: String
    ) async throws {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.notification.registerPush") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AppBskyLexicon.Notification.RegisterPushRequestBody(
            serviceDID: serviceDID,
            token: token,
            platform: platform,
            appID: appID
        )

        do {
            let request = await APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )

            _ = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
