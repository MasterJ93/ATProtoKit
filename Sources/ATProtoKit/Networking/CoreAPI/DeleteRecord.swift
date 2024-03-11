//
//  DeleteRecord.swift
//  
//
//  Created by Christopher Jr Riley on 2024-02-10.
//

import Foundation

extension ATProtoKit {
    /// Deletes a record attached to a user account..
    /// 
    /// - Note: According to the AT Protocol specifications: "Delete a repository record, or ensure it doesn't exist. Requires auth, implemented by PDS."
    ///  
    /// - Parameters:
    ///   - repositoryDID: The decentralized identifier (DID) or handle of the user account.
    ///   - collection: The NSID of the record.
    ///   - recordKey: The record key of the record.
    ///   - swapRecord: Swap the record on the server with this current record based on the CID of the record on the server.
    ///   - swapCommit: Swap the commit on the server with this current commit based on the CID of the commit on the server.
    public func deleteRecord(repositoryDID: String, collection: String, recordKey: String, swapRecord: String? = nil, swapCommit: String? = nil) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.deleteRecord") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let requestBody = RepoDeleteRecord(
            repositoryDID: repositoryDID,
            collection: collection,
            recordKey: recordKey,
            swapRecord: swapRecord,
            swapCommit: swapCommit
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: nil,
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(session.accessToken)")

            try await APIClientService.sendRequest(request, withEncodingBody: requestBody)
        } catch {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(error)"])
        }
    }
}
