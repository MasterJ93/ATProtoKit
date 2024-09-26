//
//  UploadVideo.swift
//
//
//  Created by Christopher Jr Riley on 2024-09-19.
//

import Foundation

extension ATProtoKit {

    /// Uploads a video to a user's account.
    ///
    /// - Note: According to the AT Protocol specifications: "Upload a video to be processed
    /// then stored on the PDS."
    /// - SeeAlso: This is based on the [`app.bsky.video.uploadVideo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/video/getUploadLimits.json
    ///
    /// - Parameter video: The video file itself.
    /// - Returns: An instance of a status of the video upload, which contains things like the
    /// job ID, progress, and state.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func uploadVideo(_ video: Data) async throws -> AppBskyLexicon.Video.GetJobStatusOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.video.uploadVideo") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AppBskyLexicon.Video.UploadVideoRequestBody(
            video: video
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )

            let response = try await APIClientService.shared.sendRequest(
                request,
                withDataBody: requestBody.video,
                decodeTo: AppBskyLexicon.Video.GetJobStatusOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
