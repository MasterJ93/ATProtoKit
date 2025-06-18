//
//  AppBskyVideoGetJobStatusMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-09-16.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
    public func getJobStatus(from jobID: String) async throws -> AppBskyLexicon.Video.GetJobStatusOutput {
        let service = try await self.getServiceAuthentication(from: "did:web:video.bsky.app", lexiconMethod: "app.bsky.video.getJobStatus")
        let serviceToken = service.token

        guard let requestURL = URL(string: "https://video.bsky.app/xrpc/app.bsky.video.getJobStatus") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("jobId", jobID))

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
                authorizationValue: "Bearer \(serviceToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Video.GetJobStatusOutput.self
            )

            return response

        } catch {
            throw error
        }
    }
}
