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
    /// - Note: According to the AT Protocol specifications: "Create a single new repository record. Requires auth, implemented by PDS."
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
    /// - Returns: A `Result`, containing either a ``StrongReference`` if successful, and an `Error` if not.
    public func createRecord(repositoryDID: String, collection: String, recordKey: String? = nil, shouldValidate: Bool? = true, record: UnknownType,
                             swapCommit: String? = nil) async -> Result<StrongReference, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.createRecord") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }
        
        let requestBody = RepoCreateRecord(
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
                                                                  decodeTo: StrongReference.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
