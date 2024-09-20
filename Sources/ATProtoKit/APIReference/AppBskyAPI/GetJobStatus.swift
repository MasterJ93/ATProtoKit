//
//  GetJobStatus.swift
//
//
//  Created by Christopher Jr Riley on 2024-09-16.
//

import Foundation

extension ATProtoKit {

    /// Gets the job status of a video processing job.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get status details for a video
    /// processing job."
    /// 
    /// - SeeAlso: This is based on the [`app.bsky.video.getJobStatus`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/video/getJobStatus.json
    /// 
    /// - Parameter jobID: The ID of the processing job.
    /// - Returns: The status of the video processing job from the corresponding ID.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getVideoStatus(from jobID: String) async throws -> AppBskyLexicon.Video.GetJobStatusOutput {

        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.video.getJobStatus") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("jobId", jobID))

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
                decodeTo: AppBskyLexicon.Video.GetJobStatusOutput.self
            )

            return response

        } catch {
            throw error
        }
    }
}
