//
//  AppBskyNotificationGetUnreadCountMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-15.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Counts the number of unread notifications.
    ///
    /// - Bug: The `seenAt` parameter has not yet been implemented by Bluesky. For now, leave the
    /// parameter blank.
    ///
    /// - Note: According to the AT Protocol specifications: "Count the number of unread
    /// notifications for the requesting account. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.getUnreadCount`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/getUnreadCount.json
    ///
    /// - Parameters:
    ///   - priority: Indicates whether the notification is a priority. Optional.
    ///   - seenAt: The date and time the notifications were seen. Optional. Defaults to the date and
    ///   time the request was sent.
    /// - Returns: The number of unread notifications.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getUnreadCount(
        priority: Bool?,
        seenAt: Date? = nil
    ) async throws -> AppBskyLexicon.Notification.GetUnreadCountOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.notification.getUnreadCount") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let priority {
            queryItems.append(("priority", "\(priority)"))
        }

        if let seenAt,
           let seenAtDate = CustomDateFormatter.shared.string(from: seenAt) {
            queryItems.append(("seenAt", "\(seenAtDate)"))
        }

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Notification.GetUnreadCountOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
