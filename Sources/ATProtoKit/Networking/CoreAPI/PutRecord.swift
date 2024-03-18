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
    /// - Parameters:
    ///   - repositoryDID: The decentralized identifier (DID) or handle of the repository.
    ///   - collection: The NSID of the record.
    ///   - recordKey: The record key of the collection.
    ///   - shouldValidate: Indicates whether the record should be validated. Optional. Defaults to `true`.
    ///   - record: The record itself.
    ///   - swapRecord: Swaps the record in the server with the record contained in here. Optional.
    ///   - swapCommit: Swaps the commit in the server with the commit contained in here. Optional.
    /// - Returns: A `Result`, containing either a ``StrongReference`` if successful, or an `Error` if not.
    public func putRecord(_ repositoryDID: String, collection: String, recordKey: String, shouldValidate: Bool? = true, record: UnknownType, swapRecord: String? = nil, swapCommit: String? = nil) async throws -> Result<StrongReference, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.putRecord") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let requestBody = RepoPutRecord(
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
                                                         authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, withEncodingBody: requestBody, decodeTo: StrongReference.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
