//
//  CreateLikeRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-08.
//

import Foundation

extension ATProtoKit {

    /// Create a like record to a user's post.
    /// 
    /// - Parameters:
    ///   - strongReference: The URI of the record, which contains the `recordURI` and `cidHash`.
    ///   - createdAt: The date and time the like record was created. Defaults to `Date.now`.
    ///   - shouldValidate: Indicates whether the record should be validated. Optional.
    ///   Defaults to `true`.
    /// - Returns: A
    /// ``ComAtprotoLexicon/Repository/StrongReference``
    /// structure which represents the record that was successfully created.
    public func createLikeRecord(
        _ strongReference: ComAtprotoLexicon.Repository.StrongReference,
        createdAt: Date = Date(),
        shouldValidate: Bool? = true
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session else { throw ATRequestPrepareError.missingActiveSession }

        let likeRecord = AppBskyLexicon.Feed.LikeRecord(
            subject: strongReference,
            createdAt: createdAt
        )

        return try await createRecord(
            repositoryDID: session.sessionDID,
            collection: "app.bsky.feed.like",
            shouldValidate: shouldValidate,
            record: UnknownType.record(likeRecord)
        )
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
