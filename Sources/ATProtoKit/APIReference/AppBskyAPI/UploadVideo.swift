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
    /// - Note: According to the AT Protocol specifications: "Upload a new blob, to be referenced
    /// from a repository record. The blob will be deleted if it is not referenced within a time
    /// window (eg, minutes). Blob restrictions (mimetype, size, etc) are enforced when the
    /// reference is created. Requires auth, implemented by PDS."
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
              (session?.accessToken != nil),
              let serviceEndpoint = session?.didDocument?.service[0].serviceEndpoint else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let serviceEndpointHost = serviceEndpoint.host() else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let service = try await self.getServiceAuthentication(
            from: "did:web:\(serviceEndpointHost)",
            expirationTime: 30 * 60,
            lexiconMethod: "com.atproto.repo.uploadBlob"
        )
        let serviceToken = service.token

        guard let requestURL = URL(string: "https://video.bsky.app/xrpc/app.bsky.video.uploadVideo") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AppBskyLexicon.Video.UploadVideoRequestBody(
            video: video
        )

        var queryItems = [(String, String)]()

        if let did = session?.sessionDID {
            queryItems.append(("did", did))
        }

        queryItems.append(("name", "\(ATProtoTools().generateRandomString()).mp4"))

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            var request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "video/mp4",
                authorizationValue: "Bearer \(serviceToken)"
            )
            request.httpBody = requestBody.video
            print("requestURL: \(requestURL)")

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
