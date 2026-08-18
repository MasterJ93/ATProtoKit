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

    /// Uploads raw blob data to the authenticated account's Personal Data Server (PDS).
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
    ///   - data: The raw blob data. This value becomes the complete request body.
    ///   - contentType: The media type to use for the request's `Content-Type` header.
    /// - Returns: An `UploadBlobOutput` instance with the upload result.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func uploadBlob(
        _ data: Data,
        contentType: String
    ) async throws -> ComAtprotoLexicon.Repository.UploadBlobOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let requestURL = session.serviceEndpoint
            .appendingPathComponent("xrpc")
            .appendingPathComponent("com.atproto.repo.uploadBlob")

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                contentTypeValue: contentType,
                requiresAuthorization: true
            )

            // The `com.atproto.repo.uploadBlob` endpoint wraps its result in a
            // `blob` key (`{"blob": {...}}`), unlike record fields where the blob
            // appears inline. Decode the wrapper and return its blob so uploads
            // don't fail looking for `ref` at the response root.
            let response = try await apiClientService.sendRequest(
                request,
                withDataBody: data,
                decodeTo: ComAtprotoLexicon.Repository.UploadBlobResponse.self
            )

            return response.blob
        } catch {
            throw error
        }
    }
}
