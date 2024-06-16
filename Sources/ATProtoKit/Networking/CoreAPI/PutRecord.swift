//
//  PutRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-11.
//

import Foundation

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
    ///   - repositoryDID: The decentralized identifier (DID) or handle of the repository.
    ///   - collection: The Namespaced Identifier (NSID) of the record.
    ///   - recordKey: The record key of the collection.
    ///   - shouldValidate: Indicates whether the record should be validated. Optional.
    ///   Defaults to `true`.
    ///   - record: The record itself.
    ///   - swapRecord: Swaps the record in the server with the record contained in here. Optional.
    ///   - swapCommit: Swaps the commit in the server with the commit contained in here. Optional.
    /// - Returns: A `Result`, containing either a
    /// ``ComAtprotoLexicon/Repository/StrongReference``
    /// if successful, or an `Error` if not.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func putRecord(
        _ repositoryDID: String,
        collection: String,
        recordKey: String,
        shouldValidate: Bool? = true,
        record: UnknownType,
        swapRecord: String? = nil,
        swapCommit: String? = nil
    ) async throws -> Result<ComAtprotoLexicon.Repository.StrongReference, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.putRecord") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let requestBody = ComAtprotoLexicon.Repository.PutRecordRequestBody(
            repositoryDID: repositoryDID,
            collection: collection,
            recordKey: recordKey,
            shouldValidate: shouldValidate,
            record: record,
            swapRecord: swapRecord,
            swapCommit: swapCommit
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: requestBody,
                                                                  decodeTo: ComAtprotoLexicon.Repository.StrongReference.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
