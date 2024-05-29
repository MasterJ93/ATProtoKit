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
    /// - Note: According to the AT Protocol specifications: "Count the number of unread
    /// notifications for the requesting account. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.getUnreadCount`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/getUnreadCount.json
    ///
    /// - Parameter seenAt: The date and time the notifications were seen. Defaults to the date and
    /// time the request was sent.
    /// - Returns: A `Result`, containing either a ``NotificationGetUnreadCountOutput``
    /// if successful, or an `Error` if not.
    public func getUnreadCount(
        seenAt: Date = Date.now
    ) async throws -> Result<NotificationGetUnreadCountOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.notification.getUnreadCount") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        if let seenAtDate = CustomDateFormatter.shared.string(from: seenAt) {
            queryItems.append(("seenAt", "\(seenAtDate)"))
        }

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
                                                                  decodeTo: NotificationGetUnreadCountOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
