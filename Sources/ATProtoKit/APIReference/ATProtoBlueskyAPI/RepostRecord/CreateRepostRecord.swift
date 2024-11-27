//
//  CreateRepostRecord.swift
//  
//
//  Created by Christopher Jr Riley on 2024-06-01.
//

import Foundation

extension ATProtoBluesky {
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

    return try await atProtoKitInstance.createRecord(
      repositoryDID: session.sessionDID,
      collection: "app.bsky.feed.repost",
      shouldValidate: shouldValidate,
      record: .record(repostRecord)
    )
  }

  struct RepostRecordRequestBody: Encodable {
    let repo: String
    let collection: String = "app.bsky.feed.repost"
    let record: AppBskyLexicon.Feed.RepostRecord
  }
}
