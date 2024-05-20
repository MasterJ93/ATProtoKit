//
//  ComAtprotoRepoGetRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Repository {

    /// The main data model definition for the outpot of a record.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.getRecord`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/getRecord.json
    public struct RecordOutput: Codable {

        /// The URI of the record.
        public let recordURI: String

        /// The CID hash for the record.
        public let recordCID: String

        /// The value for the record.
        public let value: RecordValueReply?

        enum CodingKeys: String, CodingKey {
            case recordURI = "uri"
            case recordCID = "cid"
            case value = "value"
        }
    }

    // MARK: -
    /// The main data model definition for the outpot .
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.getRecord`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/getRecord.json
    public struct RecordValueReply: Codable {

        /// The reply reference of the record.
        public let reply: ReplyReference?
    }
}
