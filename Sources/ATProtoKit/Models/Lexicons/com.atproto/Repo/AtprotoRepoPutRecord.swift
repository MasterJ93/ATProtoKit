//
//  AtprotoRepoPutRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-11.
//

import Foundation

/// The main data model definition for creating a record that replaces a previous record.
///
/// - Note: According to the AT Protocol specifications: "Write a repository record, creating or updating it as needed. Requires auth, implemented by PDS."
///
/// - SeeAlso: This is based on the [`com.atproto.repo.putRecord`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/putRecord.json
public struct RepoPutRecord: Codable {
    /// The decentralized identifier (DID) or handle of the repository.
    ///
    /// - Note: According to the AT Protocol specifications: "The handle or DID of the repo (aka, current account)."
    public let repositoryDID: String
    /// The NSID of the record.
    ///
    /// - Note: According to the AT Protocol specifications: "The NSID of the record collection."
    public let collection: String
    /// The record key of the collection.
    ///
    /// - Note: According to the AT Protocol specifications: "The Record Key."
    public let recordKey: String
    /// Indicates whether the record should be validated. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Can be set to 'false' to skip Lexicon schema validation of record data."
    public let shouldValidate: Bool?
    /// The record itself.
    ///
    /// - Note: According to the AT Protocol specifications: "The record to write."
    public let record: UnknownType
    /// Swaps the record in the server with the record contained in here. Optional.
    ///
    /// - Important: This field can be left blank.
    ///
    /// - Note: According to the AT Protocol specifications: "Compare and swap with the previous record by CID. WARNING: nullable and optional field; may cause problems with golang implementation"
    public let swapRecord: String?
    /// Swaps the commit in the server with the commit contained in here. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Compare and swap with the previous commit by CID."
    public let swapCommit: String?

    enum CodingKeys: String, CodingKey {
        case repositoryDID = "repo"
        case collection
        case recordKey = "rkey"
        case shouldValidate = "validate"
        case record
        case swapRecord
        case swapCommit
    }
}
