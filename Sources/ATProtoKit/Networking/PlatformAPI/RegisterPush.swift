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
    public func registerPush(serviceDID: String, token: String, platform: RegisterPushRequest.Platform, appID: String) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.notification.registerPush") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = RegisterPushRequest(
            serviceDID: serviceDID,
            token: token,
            platform: platform,
            appID: appID
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
