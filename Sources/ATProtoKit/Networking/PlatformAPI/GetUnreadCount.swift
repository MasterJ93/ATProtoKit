//
//  GetUnreadCount.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-15.
//

import Foundation

extension ATProtoKit {
    /// Counts the number of unread notifications.
    /// 
    /// - Parameter seenAt: The date and time the notifications were seen. Defaults to the date and time the request was sent.
    /// - Returns: A `Result`, containing either a ``NotificationGetUnreadCountOutput`` if successful, or an `Error` if not.
    public func getUnreadCount(seenAt: Date = Date.now) async throws -> Result<NotificationGetUnreadCountOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.notification.getUnreadCount") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        var queryItems = [(String, String)]()

        if let seenAtDate = CustomDateFormatter.shared.string(from: seenAt) {
            queryItems.append(("seenAt", "\(seenAtDate)"))
        }

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
            let response = try await APIClientService.sendRequest(request, decodeTo: NotificationGetUnreadCountOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
