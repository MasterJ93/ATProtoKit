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
    /// - Note: According to the AT Protocol specifications: "Delete a repository record, or
    /// ensure it doesn't exist. Requires auth, implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.deleteRecord`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/deleteRecord.json
    ///
    /// - Parameters:
    ///   - repositoryDID: The decentralized identifier (DID) or handle of the user account.
    ///   - collection: The Namespaced Identifier (NSID) of the record.
    ///   - recordKey: The record key of the record.
    ///   - swapRecord: Swap the record on the server with this current record based on the CID
    ///   of the record on the server.
    ///   - swapCommit: Swap the commit on the server with this current commit based on the CID
    ///   of the commit on the server.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func deleteRecord(
        repositoryDID: String,
        collection: String,
        recordKey: String,
        swapRecord: String? = nil,
        swapCommit: String? = nil
    ) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.deleteRecord") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Repository.DeleteRecordRequestBody(
            repositoryDID: repositoryDID,
            collection: collection,
            recordKey: recordKey,
            swapRecord: swapRecord,
            swapCommit: swapCommit
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: nil,
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )

            _ = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
