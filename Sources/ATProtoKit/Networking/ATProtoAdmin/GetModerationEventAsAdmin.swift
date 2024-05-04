//
//  GetModerationEventAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-01.
//

import Foundation

extension ATProtoAdmin {

    /// Gets details about a moderation event.
    /// 
    /// - Important: This is a moderator task and as such, regular users won't be able to access
    /// this; if they attempt to do so, an error will occur.
    ///
    /// - Note: According to the AT Protocol specifications: "Get details about a
    /// moderation event."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.getEvent`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/getEvent.json
    ///
    /// - Parameter id: The ID of the moderator event.
    /// - Returns: A `Result`, containing either an ``OzoneModerationEventViewDetail``
    /// if successful, or an `Error` if not.
    public func getEvent(_ id: String) async throws -> Result<OzoneModerationEventViewDetail, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.moderation.getEvent") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let queryItems = [
            ("id", id)
        ]

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
                                                                  decodeTo: OzoneModerationEventViewDetail.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
