//
//  AppBskyNotificationListNotificationsMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-15.
//

import Foundation

extension ATProtoKit {

    /// Lists notifications of the user account.
    ///
    /// - Bug: The `seenAt` parameter is currently not working. This is a known issue, as per the
    /// [GitHub Issue ticket](https://github.com/bluesky-social/atproto/issues/1636) in the
    /// atproto repo. Until it's fixed, please refrain from using this.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerate notifications for the
    /// requesting account. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.listNotifications`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/listNotifications.json
    ///
    /// - Parameters:
    ///   - reasons: An array of reasons for the notification.
    ///   ``AppBskyLexicon/Notification/Notification/reason-swift.property``. Optional.
    ///   - limit: The number of invite codes in the list. Optional. Defaults to `50`.
    ///   - isPriority: Indicates whether the notification is a priority. Optional.
    ///   Defaults to `nil`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    ///   - seenAt: The date and time the notification was seen. Defaults to the date and time the
    ///   request was sent.
    /// - Returns: An array of notifications, with an optional cursor to expand the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func listNotifications(
        with reasons: [AppBskyLexicon.Notification.Notification.Reason]? = nil,
        limit: Int? = 50,
        isPriority: Bool? = nil,
        cursor: String? = nil,
        seenAt: Date? = nil
    ) async throws -> AppBskyLexicon.Notification.ListNotificationsOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.notification.listNotifications") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let reasons {
            reasons.forEach { reason in
                queryItems.append(("reasons", "\(reason.rawValue)"))
            }
        }

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let isPriority {
            queryItems.append(("priority", "\(isPriority)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        if let seenAt, let formattedSeenAt = CustomDateFormatter.shared.string(from: seenAt) {
            queryItems.append(("seenAt", formattedSeenAt))
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
                decodeTo: AppBskyLexicon.Notification.ListNotificationsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
