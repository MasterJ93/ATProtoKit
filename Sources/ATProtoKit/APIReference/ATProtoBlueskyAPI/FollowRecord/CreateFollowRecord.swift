//
//  CreateFollowRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-01.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBluesky {

    /// Creates a follow record to follow a specific user account.
    ///
    /// - Note: A delay of 5 milliseconds is added after the follow record is created; any shorter delay
    /// may cause the next request to fail.
    ///
    /// - Parameters:
    ///   - actorDID: The decentralized identifier (DID) for the user account to follow.
    ///   - createdAt: The date and time the follow record is created. Defaults to `Date()`.
    ///   - via: A strong reference to the user account that recommended the followed account. Optional.
    ///   - recordKey: The record key of the collection. Optional. Defaults to `nil`.
    ///   - shouldValidate: Indicates whether the record should be validated. Optional.
    ///   Defaults to `true`.
    ///   - swapCommit: Swaps out an operation based on the CID. Optional. Defaults to `nil`.
    /// - Returns: A
    /// ``ComAtprotoLexicon/Repository/StrongReference``
    /// structure which represents the record that was successfully created.
    public func createFollowRecord(
        actorDID: String,
        createdAt: Date = Date(),
        via: ComAtprotoLexicon.Repository.StrongReference? = nil,
        recordKey: String? = nil,
        shouldValidate: Bool? = true,
        swapCommit: String? = nil
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session = try await atProtoKitInstance.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let followRecord = AppBskyLexicon.Graph.FollowRecord(
            subjectDID: actorDID,
            createdAt: createdAt,
            via: via
        )

        do {
            let record = try await atProtoKitInstance.createRecord(
                repositoryDID: session.sessionDID,
                collection: "app.bsky.graph.follow",
                recordKey: recordKey,
                shouldValidate: shouldValidate,
                record: UnknownType.record(followRecord),
                swapCommit: swapCommit
            )

            try await Task.sleep(nanoseconds: 500_000_000)

            return record
        } catch {
            throw error
        }
    }
}
