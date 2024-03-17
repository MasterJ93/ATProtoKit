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
    /// - Parameters:
    ///   - repositoryDID: The decentralized identifier (DID) of the repository.
    ///   - collection: The NSID of the record.
    ///   - recordKey: The record key of the collection. Optional.
    ///   - shouldValidate: ndicates whether the record should be validated. Optional. Defaults to `true`.
    ///   - record: /// The record itself.
    ///   - swapCommit: Swaps out an operation based on the CID. Optional.
    /// - Returns: A `Result`, containing either a ``StrongReference`` if successful, and an `Error` if not.
    public func createRecord(repositoryDID: String, collection: String, recordKey: String? = nil, shouldValidate: Bool? = true, record: UnknownType, swapCommit: String? = nil) async -> Result<StrongReference, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.createRecord") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }
        
        let requestBody = RepoCreateRecord(
            repositoryDID: repositoryDID,
            collection: collection,
            recordKey: recordKey,
            shouldValidate: shouldValidate,
            record: record,
            swapCommit: swapCommit)

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, withEncodingBody: requestBody, decodeTo: StrongReference.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
