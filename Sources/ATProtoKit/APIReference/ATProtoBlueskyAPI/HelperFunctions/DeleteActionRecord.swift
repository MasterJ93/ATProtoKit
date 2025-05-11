//
//  DeleteActionRecord.swift
//
//
//  Created by Andy Lin on 11/27/24.
//

import Foundation

extension ATProtoBluesky {
    
    /// Deletes a record.
    ///
    /// This can also be used to validate if a record has been deleted.
    /// - Parameter record: The record that needs to be deleted.
    ///
    /// This can be either the URI of the record, or the full record object itself.
    internal func deleteActionRecord(_ record: RecordIdentifier) async throws {
        guard let session = try await atProtoKitInstance.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var actionRecord: ATProtoTools.RecordQuery? = nil
        try await resolveRecordIdentifierToQuery(record, sessionURL, &actionRecord)

        let requestBody = actionRecord

        guard let repositoryDID = requestBody?.repository,
              let actionCollection = requestBody?.collection,
              let actionRecordKey = requestBody?.recordKey else {
            throw ATRequestPrepareError.invalidRecord
        }

        try await atProtoKitInstance.deleteRecord(
            repositoryDID: repositoryDID,
            collection: actionCollection,
            recordKey: actionRecordKey,
            swapRecord: requestBody?.recordCID
        )
    }

    fileprivate func resolveRecordIdentifierToQuery(_ record: RecordIdentifier, _ sessionURL: String,
                                                    _ actionRecord: inout ATProtoTools.RecordQuery?) async throws {
        switch record {
            case .recordQuery(let recordQuery):
                do {
                    // Perform the fetch and validation based on recordQuery.
                    let output = try await atProtoKitInstance.getRepositoryRecord(from: recordQuery.repository,
                                                                                  collection: recordQuery.collection,
                                                                                  recordKey: recordQuery.recordKey,
                                                                                  recordCID: recordQuery.recordCID
                    )

                    let recordURI = "at://\(recordQuery.repository)/\(recordQuery.collection)/\(recordQuery.recordKey)"

                    guard output.uri == recordURI else {
                        throw ATRequestPrepareError.invalidRecord
                    }
                } catch {
                    throw error
                }

            case .recordURI(let recordURI):
                do {
                    // Perform the fetch and validation based on the parsed URI.
                    let parsedURI = try ATProtoTools().parseURI(recordURI)
                    let output = try await atProtoKitInstance.getRepositoryRecord(from: parsedURI.repository,
                                                                                  collection: parsedURI.collection,
                                                                                  recordKey: parsedURI.recordKey,
                                                                                  recordCID: parsedURI.recordCID
                    )

                    guard recordURI == output.uri else {
                        throw ATRequestPrepareError.invalidRecord
                    }

                    actionRecord = parsedURI
                } catch {
                    throw error
                }
        }
    }
    
    /// Identifies the record based on the specific information provided.
    ///
    /// `RecordIdentifier` provides a unified interface for specifying how the record is defined.
    public enum RecordIdentifier {

        /// The record object itself.
        ///
        /// - Parameter recordQuery: the record object.
        case recordQuery(recordQuery: ATProtoTools.RecordQuery)

        /// The URI of the record.
        case recordURI(atURI: String)
    }
}
