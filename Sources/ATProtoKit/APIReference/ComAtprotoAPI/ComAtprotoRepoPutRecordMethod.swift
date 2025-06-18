//
//  ComAtprotoRepoPutRecordMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-11.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Writes a record in the repository, which may replace a previous record.
    /// 
    /// - Note: According to the AT Protocol specifications: "Write a repository record, creating
    /// or updating it as needed. Requires auth, implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.putRecord`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/putRecord.json
    ///
    /// - Parameters:
    ///   - repository: The decentralized identifier (DID) or handle of the repository.
    ///   - collection: The Namespaced Identifier (NSID) of the record.
    ///   - recordKey: The record key of the collection.
    ///   - shouldValidate: Indicates whether the record should be validated. Optional.
    ///   Defaults to `true`.
    ///   - record: The record itself.
    ///   - swapRecord: Swaps the record in the server with the record contained in here. Optional.
    ///   - swapCommit: Swaps the commit in the server with the commit contained in here. Optional.
    /// - Returns: A
    /// ``ComAtprotoLexicon/Repository/StrongReference``
    /// structure which represents the record that was successfully created.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func putRecord(
        repository: String,
        collection: String,
        recordKey: String,
        shouldValidate: Bool? = true,
        record: UnknownType,
        swapRecord: String? = nil,
        swapCommit: String? = nil
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.putRecord") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Repository.PutRecordRequestBody(
            repository: repository,
            collection: collection,
            recordKey: recordKey,
            shouldValidate: shouldValidate,
            record: record,
            swapRecord: swapRecord,
            swapCommit: swapCommit
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ComAtprotoLexicon.Repository.StrongReference.self
            )

            return response
        } catch {
            throw error
        }
    }
}
