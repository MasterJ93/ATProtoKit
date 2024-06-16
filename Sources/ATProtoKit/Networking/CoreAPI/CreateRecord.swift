//
//  CreateRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-10.
//

import Foundation

extension ATProtoKit {

    /// Creates a record attached to a user account.
    ///  
    /// - Warning: If you're using a lexicon that's not made by `com.atproto` or `app.bsky`,
    /// make sure you set `shouldValidate` to `false`. Failure to do so will result in an error
    /// that the lexicon isn't found.
    ///
    /// - Note: According to the AT Protocol specifications: "Create a single new repository
    /// record. Requires auth, implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.createRecord`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/createRecord.json
    ///
    /// - Parameters:
    ///   - repositoryDID: The decentralized identifier (DID) of the repository.
    ///   - collection: The Namespaced Identifier (NSID) of the record.
    ///   - recordKey: The record key of the collection. Optional.
    ///   - shouldValidate: ndicates whether the record should be validated. Optional. Defaults to `true`.
    ///   - record: The record itself.
    ///   - swapCommit: Swaps out an operation based on the CID. Optional.
    /// - Returns: A `Result`, containing either a
    /// ``ComAtprotoLexicon/Repository/StrongReference``
    /// if successful, and an `Error` if not.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func createRecord(
        repositoryDID: String,
        collection: String,
        recordKey: String? = nil,
        shouldValidate: Bool? = true,
        record: UnknownType,
        swapCommit: String? = nil
    ) async -> Result<ComAtprotoLexicon.Repository.StrongReference, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.createRecord") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }
        
        let requestBody = ComAtprotoLexicon.Repository.CreateRecordRequestBody(
            repositoryDID: repositoryDID,
            collection: collection,
            recordKey: recordKey,
            shouldValidate: shouldValidate,
            record: record,
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
