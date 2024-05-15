//
//  DeleteLike.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-10.
//

import Foundation

extension ATProtoKit {

    /// Deletes a like record.
    ///
    /// This can also be used to validate if a like record has been deleted.
    /// - Parameter record: The record that needs to be deleted.
    ///
    /// This can be either the URI of the record, or the full record object itself.
    public func deleteLikeRecord(_ record: RecordIdentifier) async throws {
        guard let session else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var likeRecord: RecordQuery? = nil
        try await resolveRecordIdentifierToQuery(record, sessionURL, &likeRecord)

        let requestBody = likeRecord

        guard let repositoryDID = requestBody?.repo,
              let likeCollection = requestBody?.collection,
              let likeRecordKey = requestBody?.recordKey else {
            throw ATRequestPrepareError.invalidRecord
        }

        try await deleteRecord(repositoryDID: repositoryDID, collection: likeCollection, recordKey: likeRecordKey, swapRecord: requestBody?.recordCID)
    }

    fileprivate func resolveRecordIdentifierToQuery(_ record: RecordIdentifier, _ sessionURL: String,
                                                    _ likeRecord: inout RecordQuery?) async throws {
        switch record {
            case .recordQuery(let recordQuery):
                // Perform the fetch and validation based on recordQuery.
                let output = try await ATProtoKit().getRepositoryRecord(from: recordQuery, pdsURL: sessionURL)

                switch output {
                    case .success(let result):
                        let recordURI = "at://\(recordQuery.repo)/\(recordQuery.collection)/\(recordQuery.recordKey)"
                        guard result.recordURI == recordURI else {
                            throw ATRequestPrepareError.invalidRecord
                        }

                        likeRecord = recordQuery
                    case .failure(let error):
                        throw error
                }

            case .recordURI(let recordURI):
                // Perform the fetch and validation based on the parsed URI.
                let parsedURI = try ATProtoTools().parseURI(recordURI)
                let output = try await ATProtoKit().getRepositoryRecord(from: parsedURI, pdsURL: sessionURL)

                switch output {
                    case .success(let result):
                        guard recordURI == result.recordURI else {
                            throw ATRequestPrepareError.invalidRecord
                        }

                        likeRecord = parsedURI
                    case .failure(let error):
                        throw error
                }
        }
    }
    
    /// Identifies the record based on the specific information provided.
    ///
    /// `RecordIdentifier` provides a unified interface for specifying how the record is defined.
    /// This allows methods like ``deleteLikeRecord(_:)`` to handle the backend of how to grab the
    /// details of the record so it can delete it.
    public enum RecordIdentifier {
        /// The record object itself.
        /// - Parameter recordQuery: the record object.
        case recordQuery(recordQuery: RecordQuery)
        /// The URI of the record.
        case recordURI(atURI: String)
    }
}
