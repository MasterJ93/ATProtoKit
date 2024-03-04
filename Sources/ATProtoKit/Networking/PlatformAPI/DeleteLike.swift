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
        guard let sessionURL = session.pdsURL else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var likeRecord: RecordQuery? = nil
        try await resolveRecordIdentifierToQuery(record, sessionURL, &likeRecord)

        let requestBody = likeRecord

        try await deleteRecord(requestBody: requestBody)
    }

    fileprivate func resolveRecordIdentifierToQuery(_ record: ATProtoKit.RecordIdentifier, _ sessionURL: String,
                                                    _ likeRecord: inout RecordQuery?) async throws {
        switch record {
            case .recordQuery(let recordQuery):
                // Perform the fetch and validation based on recordQuery.
                let output = try await ATProtoKit.getRepoRecord(from: recordQuery, pdsURL: sessionURL)

                switch output {
                    case .success(let result):
                        let recordURI = "at://\(recordQuery.repo)/\(recordQuery.collection)/\(recordQuery.recordKey)"
                        guard result.recordURI == recordURI else {
                            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Record"])
                        }

                        likeRecord = recordQuery
                    case .failure(let error):
                        throw error
                }

            case .recordURI(let recordURI):
                // Perform the fetch and validation based on the parsed URI.
                let parsedURI = try ATProtoKit.parseURI(recordURI)
                let output = try await ATProtoKit.getRepoRecord(from: parsedURI, pdsURL: sessionURL)

                switch output {
                    case .success(let result):
                        guard recordURI == result.recordURI else {
                            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Record"])
                        }

                        likeRecord = parsedURI
                    case .failure(let error):
                        throw error
                }
        }
    }
    
    /// Identifies the record based on the specific information provided.
    ///
    /// `RecordIdentifier` provides a unified interface for specifying how the record is defined. This allows methods like ``deleteLikeRecord(_:)`` to handle the backend of how to grab the details
    /// of the record so it can delete it.
    public enum RecordIdentifier {
        /// The record object itself.
        /// - Parameter recordQuery: the record object.
        case recordQuery(recordQuery: RecordQuery)
        /// The URI of the record.
        case recordURI(atURI: String)
    }
}
