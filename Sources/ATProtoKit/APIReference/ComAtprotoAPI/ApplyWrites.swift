//
//  ApplyWrites.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-11.
//

import Foundation

extension ATProtoKit {

    /// Applies creation, updates, and deletion transactions into the repository in batches.
    /// 
    /// - Note: According to the AT Protocol specifications: "Apply a batch transaction of
    /// repository creates, updates, and deletes. Requires auth, implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.applyWrites`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/applyWrites.json
    ///
    /// - Parameters:
    ///   - repositoryDID: The decentralized identifier (DID) or handle of the repository.
    ///   - shouldValidate: Indicates whether the operation should be validated. Optional. Defaults to `true`.
    ///   - writes: The write operation itself.
    ///   - swapCommit: Swaps out an operation based on the CID. Optional.
    ///
    ///   - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func applyWrites(
        _ repositoryDID: String,
        shouldValidate: Bool? = true,
        writes: [ATUnion.ApplyWritesUnion],
        swapCommit: String? = nil
    ) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.applyWrites") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Repository.ApplyWritesRequestBody(
            repositoryDID: repositoryDID,
            shouldValidate: shouldValidate,
            writes: writes,
            swapCommit: swapCommit
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: nil,
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(accessToken)")

            try await APIClientService.sendRequest(request,
                                                   withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
