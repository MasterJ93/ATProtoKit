//
//  ComAtprotoRepoUploadBlobMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-08-16.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
    /// - Returns: An `UploadBlobOutput` instance with the upload result.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func uploadBlob(
        pdsURL: String = "https://bsky.social",
        accessToken: String,
        filename: String,
        imageData: Data
    ) async throws -> ComAtprotoLexicon.Repository.UploadBlobOutput {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.repo.uploadBlob") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let mimeType = APIClientService.mimeType(for: filename)

        do {
            var request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                contentTypeValue: mimeType,
                authorizationValue: "Bearer \(accessToken)")
            request.httpBody = imageData

            // The `com.atproto.repo.uploadBlob` endpoint wraps its result in a
            // `blob` key (`{"blob": {...}}`), unlike record fields where the blob
            // appears inline. Decode the wrapper and return its blob so uploads
            // don't fail looking for `ref` at the response root.
            let response = try await apiClientService.sendRequest(request,
                                                      decodeTo: UploadBlobResponse.self)

            return response.blob
        } catch {
            throw error
        }
    }
}

/// The response envelope for `com.atproto.repo.uploadBlob`, which returns the
/// uploaded blob under a `blob` key.
private struct UploadBlobResponse: Decodable {
    let blob: ComAtprotoLexicon.Repository.UploadBlobOutput
}
