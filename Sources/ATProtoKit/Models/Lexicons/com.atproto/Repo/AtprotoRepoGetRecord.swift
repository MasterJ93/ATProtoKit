//
//  AtprotoRepoGetRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-29.
//

import Foundation

// MARK: - Main definition
/// The main data model definition for a record.
///
/// - Note: According to the AT Protocol specifications: "Get a single record from a repository. Does not require auth."
///
/// - SeeAlso: This is based on the [`com.atproto.repo.getRecord`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/getRecord.json
public struct RecordQuery: Codable {
    /// The handle or decentralized identifier (DID) of the repo."
    ///
    /// - Note: According to the AT Protocol specifications: "The handle or DID of the repo."
    public let repo: String
    /// The NSID of the record.
    ///
    /// - Note: According to the AT Protocol specifications: "The NSID of the record collection."
    public let collection: String
    /// The record's key.
    ///
    //// - Note: According to the AT Protocol specifications: "The Record Key."
    public let recordKey: String
    /// The CID of the version of the record. Optional. If not specified, then return the most recent version.
    ///
    /// - Note: According to the AT Protocol specifications: "The CID of the version of the record. If not specified, then return the most recent version."
    public let recordCID: String? = nil

    public init(repo: String, collection: String, recordKey: String) {
        self.repo = repo
        self.collection = collection
        self.recordKey = recordKey
    }

    enum CodingKeys: String, CodingKey {
        case repo = "repo"
        case collection = "collection"
        case recordKey = "rkey"
        case recordCID = "cid"
    }
}

// MARK: -
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
