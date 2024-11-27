//
//  DeleteRepostRecord.swift
//  
//
//  Created by Christopher Jr Riley on 2024-06-01.
//

import Foundation

extension ATProtoBluesky {

  /// Deletes a repost record.
  ///
  /// This can also be used to validate if a repost record has been deleted.
  /// - Parameter record: The record that needs to be deleted.
  ///
  /// This can be either the URI of the record, or the full record object itself.
  public func deleteRepostRecord(_ record: RecordIdentifier) async throws {
    guard let session else {
      throw ATRequestPrepareError.missingActiveSession
    }

    guard let sessionURL = session.pdsURL else {
      throw ATRequestPrepareError.invalidRequestURL
    }

    var repostRecord: ATProtoTools.RecordQuery? = nil
    try await resolveRecordIdentifierToQuery(record, sessionURL, &repostRecord)

    let requestBody = repostRecord

    guard let repositoryDID = requestBody?.repository,
          let repostCollection = requestBody?.collection,
          let repostRecordKey = requestBody?.recordKey else {
      throw ATRequestPrepareError.invalidRecord
    }

    try await atProtoKitInstance.deleteRecord(
      repositoryDID: repositoryDID,
      collection: repostCollection,
      recordKey: repostRecordKey,
      swapRecord: requestBody?.recordCID
    )
  }

  fileprivate func resolveRecordIdentifierToQuery(
    _ record: RecordIdentifier,
    _ sessionURL: String,
    _ repostRecord: inout ATProtoTools.RecordQuery?
  ) async throws {
    switch record {
    case .recordQuery(let recordQuery):
      do {
        // Perform the fetch and validation based on recordQuery.
        let output = try await atProtoKitInstance.getRepositoryRecord(
          from: recordQuery.repository,
          collection: recordQuery.collection,
          recordKey: recordQuery.recordKey,
          recordCID: recordQuery.recordCID,
          pdsURL: sessionURL
        )

        let recordURI = "at://\(recordQuery.repository)/\(recordQuery.collection)/\(recordQuery.recordKey)"

        guard output.recordURI == recordURI else {
          throw ATRequestPrepareError.invalidRecord
        }
      } catch {
        throw error
      }

    case .recordURI(let recordURI):
      do {
        // Perform the fetch and validation based on the parsed URI.
        let parsedURI = try ATProtoTools().parseURI(recordURI)
        let output = try await atProtoKitInstance.getRepositoryRecord(
          from: parsedURI.repository,
          collection: parsedURI.collection,
          recordKey: parsedURI.recordKey,
          recordCID: parsedURI.recordCID,
          pdsURL: sessionURL
        )

        guard recordURI == output.recordURI else {
          throw ATRequestPrepareError.invalidRecord
        }

        repostRecord = parsedURI
      } catch {
        throw error
      }
    }
  }
}
