//
//  CreateLike.swift
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
    /// - Returns: A `Result`, containing either a ``StrongReference``
    /// if it's successful, or an `Error` if it's not.
    public func createLikeRecord(_ strongReference: StrongReference, createdAt: Date = Date.now,
                                 shouldValidate: Bool? = true) async throws -> Result<StrongReference, Error> {
//        guard let sessionURL = session.pdsURL,
//              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.createRecord") else {
//            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
//        }

        guard let session else { return .failure(ATRequestPrepareError.missingActiveSession) }

        let likeRecord = FeedLike(
            subject: strongReference,
            createdAt: createdAt
        )

        return await createRecord(
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
        let record: FeedLike
    }
}
