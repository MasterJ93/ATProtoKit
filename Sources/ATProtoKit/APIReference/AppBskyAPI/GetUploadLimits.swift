//
//  GetUploadLimits.swift
//
//
//  Created by Christopher Jr Riley on 2024-09-16.
//

import Foundation

extension ATProtoKit {

    /// Gets the user account's current limit for videos.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get video upload limits for the
    /// authenticated user."
    /// 
    /// - SeeAlso: This is based on the [`app.bsky.video.getUploadLimits`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/video/getUploadLimits.json
    /// 
    /// - Returns: Details on the number of videos and bytes that are remaining to be used for
    /// the day by the user account.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getUploadLimits() async throws -> AppBskyLexicon.Video.GetUploadLimitsOutput {

        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.video.getUploadLimits") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Video.GetUploadLimitsOutput.self
            )

            return response

        } catch {
            throw error
        }
    }
}
