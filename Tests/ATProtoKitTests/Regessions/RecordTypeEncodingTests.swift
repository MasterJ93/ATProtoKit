//
//  RecordTypeEncodingTests.swift
//  ATProtoKit
//
//  Created by Aaron Vegh on 2026-09-17.
//

import Foundation
import Testing
@testable import ATProtoKit

extension RegressionTests {

    /// Every record written to a repository must carry its own `$type`.
    ///
    /// A record's `$type` identifies its lexicon inside the repository, independently of the
    /// `collection` parameter of `com.atproto.repo.createRecord`. The reference PDS infers a
    /// missing `$type` from `collection` and accepts the record anyway, so an omission stays
    /// invisible there; other implementations reject the write instead.
    @Suite("Record $type Encoding Tests")
    struct RecordTypeEncodingTests {

        /// Encodes a record and returns its top-level `$type`, or `nil` when it encodes none.
        private static func encodedType(_ record: some ATRecordProtocol) throws -> String? {
            let data = try JSONEncoder().encode(record)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json?["$type"] as? String
        }

        private static let subject = ComAtprotoLexicon.Repository.StrongReference(
            recordURI: "at://did:plc:example/app.bsky.feed.post/abc123",
            cidHash: "bafyreiexamplecidvalueforthisregressiontestonly"
        )

        @Test("A like record encodes its $type")
        func likeRecordEncodesType() throws {
            let record = AppBskyLexicon.Feed.LikeRecord(subject: Self.subject, createdAt: Date(), via: nil)

            #expect(try Self.encodedType(record) == AppBskyLexicon.Feed.LikeRecord.type)
        }

        @Test("A repost record encodes its $type")
        func repostRecordEncodesType() throws {
            let record = AppBskyLexicon.Feed.RepostRecord(subject: Self.subject, createdAt: Date(), via: nil)

            #expect(try Self.encodedType(record) == AppBskyLexicon.Feed.RepostRecord.type)
        }

        @Test("A follow record encodes its $type")
        func followRecordEncodesType() throws {
            let record = AppBskyLexicon.Graph.FollowRecord(
                subjectDID: "did:plc:example",
                createdAt: Date(),
                via: nil
            )

            #expect(try Self.encodedType(record) == AppBskyLexicon.Graph.FollowRecord.type)
        }

        @Test("A block record encodes its $type")
        func blockRecordEncodesType() throws {
            let record = AppBskyLexicon.Graph.BlockRecord(subjectDID: "did:plc:example", createdAt: Date())

            #expect(try Self.encodedType(record) == AppBskyLexicon.Graph.BlockRecord.type)
        }

        @Test("A post record encodes its $type")
        func postRecordEncodesType() throws {
            let record = AppBskyLexicon.Feed.PostRecord(
                text: "Regression coverage for $type encoding.",
                facets: nil,
                reply: nil,
                embed: nil,
                languages: nil,
                labels: nil,
                tags: nil,
                createdAt: Date()
            )

            #expect(try Self.encodedType(record) == AppBskyLexicon.Feed.PostRecord.type)
        }
    }
}
