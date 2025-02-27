//
//  CreateRepostRecord.swift
//  
//
//  Created by Christopher Jr Riley on 2024-06-01.
//

import Foundation

extension ATProtoBluesky {

    /// Create a repost record to a user's post.
    ///
    /// - Parameters:
    ///   - strongReference: The URI of the record, which contains the `recordURI` and `cidHash`.
    ///   - createdAt: The date and time the like record was created. Defaults to `Date.now`.
    ///   - shouldValidate: Indicates whether the record should be validated. Optional.
    ///   Defaults to `true`.
    /// - Returns: A
    /// ``ComAtprotoLexicon/Repository/StrongReference``
    /// structure which represents the record that was successfully created.
    public func createRepostRecord(
        _ strongReference: ComAtprotoLexicon.Repository.StrongReference,
        createdAt: Date = Date(),
        shouldValidate: Bool? = true
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session else { throw ATRequestPrepareError.missingActiveSession }

        let repostRecord = AppBskyLexicon.Feed.RepostRecord(
            subject: strongReference,
            createdAt: createdAt
        )

        do {
            return try await atProtoKitInstance.createRecord(
                repositoryDID: session.sessionDID,
                collection: "app.bsky.feed.repost",
                shouldValidate: shouldValidate,
                record: UnknownType.record(repostRecord)
            )
        } catch {
            throw error
        }
    }
    
    /// The request body for a repost record.
    struct RepostRecordRequestBody: Encodable {
        /// The repository for the repost record.
        let repo: String
        /// The Namespaced Identifiers (NSID) of the request body.
        ///
        /// - Warning: The value must not change.
        let collection: String = "app.bsky.feed.repost"
        /// The like record itself.
        let record: AppBskyLexicon.Feed.RepostRecord
    }
}
