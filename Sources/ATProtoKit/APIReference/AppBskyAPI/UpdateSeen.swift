//
//  UpdateSeen.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-15.
//

import Foundation

extension ATProtoKit {

    /// Updates the server of the user seeing the notification.
    /// 
    /// - Note: According to the AT Protocol specifications: "Notify server that the requesting
    /// account has seen notifications. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.updateSeen`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/updateSeen.json
    ///
    /// - Parameter seenAt: The date and time the notification was seen. Defaults to the date and
    /// time the request was sent.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func updateSeen(seenAt: Date = Date()) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.serviceEndpoint,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.notification.updateSeen") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AppBskyLexicon.Notification.UpdateSeenRequestBody(
            seenAt: seenAt
        )

        do {
            let request = APIClientService.createRequest(
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
