//
//  ComAtprotoRepoApplyWritesMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-11.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
    ///   - did: The decentralized identifier (DID) or handle of the repository.
    ///   - shouldValidate: Indicates whether the operation should be validated. Optional. Defaults to `true`.
    ///   - writes: The write operation itself.
    ///   - swapCommit: Swaps out an operation based on the CID. Optional.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func applyWrites(
        repository did: String,
        shouldValidate: Bool? = true,
        writes: [ComAtprotoLexicon.Repository.ApplyWritesRequestBody.WritesUnion],
        swapCommit: String? = nil
    ) async throws {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.applyWrites") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Repository.ApplyWritesRequestBody(
            repositoryDID: did,
            shouldValidate: shouldValidate,
            writes: writes,
            swapCommit: swapCommit
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: nil,
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )

            _ = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
