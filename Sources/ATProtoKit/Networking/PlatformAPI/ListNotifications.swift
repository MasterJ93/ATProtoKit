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
    /// - Parameters:
    ///   - limit: The number of invite codes in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of results. Optional.
    ///   - seenAt: The date and time the notification was seen. Defaults to the date and time the request was sent.
    /// - Returns: A `Result`, containing either a ``NotificationListNotificationsOutput`` if successful, or an `Error` if not.
    public func listNotifications(withLimitOf limit: Int? = 50, cursor: String? = nil, seenAt: Date = Date.now) async throws -> Result<NotificationListNotificationsOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/`app.bsky.notification.listNotifications") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        var queryItems = [(String, String)]()

        if let limit {
            let finalLimit = min(1, max(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("limit", cursor))
        }

        guard let formattedSeenAt = CustomDateFormatter.shared.string(from: seenAt) else {
            return .failure(URIError.invalidFormat)
        }
        queryItems.append(("seenAt", formattedSeenAt))

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, decodeTo: NotificationListNotificationsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
