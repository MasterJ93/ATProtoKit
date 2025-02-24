//
//  CreateFollowRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-01.
//

import Foundation

extension ATProtoBluesky {

    /// Creates a follow record to follow a specific user account.
    ///
    /// - Parameters:
    ///   - actorDID: The decentralized identifier (DID) for the user account to follow.
    ///   - createdAt: The date and time the follow record is created. Defaults to `Date()`.
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
        recordKey: String? = nil,
        shouldValidate: Bool? = true,
        swapCommit: String? = nil
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let followRecord = AppBskyLexicon.Graph.FollowRecord(
            subjectDID: actorDID,
            createdAt: createdAt
        )

        do {
            return try await atProtoKitInstance.createRecord(
                repositoryDID: session.sessionDID,
                collection: "app.bsky.graph.follow",
                recordKey: recordKey,
                shouldValidate: shouldValidate,
                record: UnknownType.record(followRecord),
                swapCommit: swapCommit
            )
        } catch {
            throw error
        }
    }
}
