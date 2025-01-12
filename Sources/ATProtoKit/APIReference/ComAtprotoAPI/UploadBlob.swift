//
//  UploadBlob.swift
//
//
//  Created by Christopher Jr Riley on 2024-08-16.
//

import Foundation

extension ATProtoKit {

    /// Uploads a blob to a specified URL with multipart/form-data encoding.
    ///
    /// - Note: According to the AT Protocol specifications: "Upload a new blob, to be referenced
    /// from a repository record. The blob will be deleted if it is not referenced within a time
    /// window (eg, minutes). Blob restrictions (mimetype, size, etc) are enforced when the
    /// reference is created. Requires auth, implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.uploadBlob`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/uploadBlob.json
    ///
    /// - Parameters:
    ///   - pdsURL: The base URL for the blob upload.
    ///   - accessToken: The access token for authorization.
    ///   - filename: The filename of the blob to upload.
    ///   - imageData: The data of the blob to upload.
    /// - Returns: A `BlobContainer` instance with the upload result.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func uploadBlob(
        pdsURL: String = "https://bsky.social",
        accessToken: String,
        filename: String,
        imageData: Data
    ) async throws -> ComAtprotoLexicon.Repository.BlobContainer {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.repo.uploadBlob") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let mimeType = APIClientService.mimeType(for: filename)

        do {
            var request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                contentTypeValue: mimeType,
                authorizationValue: "Bearer \(accessToken)")
            request.httpBody = imageData

            let response = try await APIClientService.shared.sendRequest(request,
                                                      decodeTo: ComAtprotoLexicon.Repository.BlobContainer.self)

            return response
        } catch {
            throw error
        }
    }
}
