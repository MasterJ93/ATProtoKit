//
//  AppBskyContactSendNotificationMethod.swift
//  ATProtoKit
//
//  Created by KC-2001MS on 2026-08-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Sends a contact import notification from one user to another.
    ///
    /// - Important: This is a system endpoint that requires role authentication. It is intended
    /// for internal server use and is not available to regular user sessions.
    ///
    /// - Note: According to the AT Protocol specifications: "System endpoint to send notifications
    /// related to contact imports. Requires role authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.sendNotification`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/sendNotification.json
    ///
    /// - Parameters:
    ///   - fromDID: The decentralized identifier (DID) of the notification sender.
    ///   - toDID: The decentralized identifier (DID) of the notification recipient.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func sendNotification(fromDID: String, toDID: String) async throws {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.contact.sendNotification") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AppBskyLexicon.Contact.SendNotificationRequestBody(
            fromDID: fromDID,
            toDID: toDID
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                requiresAuthorization: true
            )

            _ = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
