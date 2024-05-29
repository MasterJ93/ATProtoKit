//
//  ListNotifications.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-15.
//

import Foundation

extension ATProtoKit {

    /// Lists notifications of the user account.
    /// 
    /// - Note: According to the AT Protocol specifications: "Enumerate notifications for the
    /// requesting account. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.listNotifications`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/listNotifications.json
    ///
    /// - Parameters:
    ///   - limit: The number of invite codes in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   results. Optional.
    ///   - seenAt: The date and time the notification was seen. Defaults to the date and time the
    ///   request was sent.
    /// - Returns: A `Result`, containing either a ``NotificationListNotificationsOutput``
    /// if successful, or an `Error` if not.
    public func listNotifications(
        withLimitOf limit: Int? = 50,
        cursor: String? = nil,
        seenAt: Date = Date.now
    ) async throws -> Result<NotificationListNotificationsOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.notification.listNotifications") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        guard let formattedSeenAt = CustomDateFormatter.shared.string(from: seenAt) else {
            return .failure(ATRequestPrepareError.invalidFormat)
        }

        queryItems.append(("seenAt", formattedSeenAt))

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: NotificationListNotificationsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
