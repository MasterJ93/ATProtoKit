//
//  CreateLike.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-08.
//

import Foundation

extension ATProtoKit {
    public func createLikeRecord(_ strongReference: StrongReference, createdAt: Date = Date.now) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.createRecord") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let likeRecord = FeedLike(
            recordURI: strongReference.recordURI,
            cidHash: strongReference.cidHash,
            createdAt: createdAt
        )

        let requestBody = LikeRecordRequestBody(
            repo: session.atDID,
            record: likeRecord
        )

        
    }

    struct LikeRecordRequestBody: Encodable {
        let repo: String
        let collection: String = "app.bsky.feed.like"
        let record: FeedLike
    }
}
