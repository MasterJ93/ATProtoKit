//
//  CreateLikeRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-08.
//

import Foundation

extension ATProtoBluesky {

    /// A convenience method to create a like record to the user account in Bluesky.
    ///
    /// This record is loosely linked to the post that the user account is liking.
    ///
    /// - Parameters:
    ///   - strongReference: The URI of the record, which contains the `recordURI` and `cidHash`.
    ///   - createdAt: The date and time the like record was created. Defaults to `Date.now`.
    ///   - via: A strong reference of a referred like. Optional. Defaults to `nil`.
    ///   - recordKey: The record key of the collection. Optional. Defaults to `nil`.
    ///   - shouldValidate: Indicates whether the record should be validated. Optional.
    ///   Defaults to `true`.
    ///   - swapCommit: Swaps out an operation based on the CID. Optional. Defaults to `nil`.
    /// - Returns: A
    /// ``ComAtprotoLexicon/Repository/StrongReference``
    /// structure which represents the record that was successfully created.
    public func createLikeRecord(
        _ strongReference: ComAtprotoLexicon.Repository.StrongReference,
        createdAt: Date = Date(),
        via: ComAtprotoLexicon.Repository.StrongReference? = nil,
        recordKey: String? = nil,
        shouldValidate: Bool? = true,
        swapCommit: String? = nil
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session = try await atProtoKitInstance.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let likeRecord = AppBskyLexicon.Feed.LikeRecord(
            subject: strongReference,
            createdAt: createdAt,
            via: via
        )

        do {
            let record = try await atProtoKitInstance.createRecord(
                repositoryDID: session.sessionDID,
                collection: "app.bsky.feed.like",
                recordKey: recordKey,
                shouldValidate: shouldValidate,
                record: UnknownType.record(likeRecord),
                swapCommit: swapCommit
            )

            try await Task.sleep(nanoseconds: 500_000_000)

            return record
        } catch {
            throw error
        }
    }
    
    /// The request body for a like record.
    struct LikeRecordRequestBody: Encodable {
        /// The repository for the like record.
        let repo: String
        /// The Namespaced Identifiers (NSID) of the request body.
        ///
        /// - Warning: The value must not change.
        let collection: String = "app.bsky.feed.like"
        /// The like record itself.
        let record: AppBskyLexicon.Feed.LikeRecord
    }
}
