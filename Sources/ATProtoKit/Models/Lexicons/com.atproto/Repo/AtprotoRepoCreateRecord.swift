//
//  AtprotoRepoCreateRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-11.
//

import Foundation

/// The main data model definition for creating a record.
///
/// - Note: According to the AT Protocol specifications: "Create a single new repository record. Requires auth, implemented by PDS."
///
/// - SeeAlso: This is based on the [`com.atproto.repo.createRecord`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/createRecord.json
public struct RepoCreateRecord: Codable {
    /// The decentralized identifier (DID) or handle of the user account.
    ///
    /// - Note: According to the AT Protocol specifications: "The handle or DID of the repo (aka, current account)."
    public let repositoryDID: String
    /// The NSID of the record.
    ///
    /// - Note: According to the AT Protocol specifications: "The NSID of the record collection."
    public let collection: String
    /// The record key of the collection. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "The Record Key."
    public let recordKey: String?
    /// Indicates whether the record should be validated. Optional. Defaults to `true`.
    public let shouldValidate: Bool?
    /// The record itself.
    public let record: UnknownType
    /// Swaps out an operation based on the CID. Optional.
    ///
    /// - Important: If a value is entered in here, the entire operation will fail if there is no matching value in the repository.
    ///
    /// - Note: According to the AT Protocol specifications: "Compare and swap with the previous commit by CID."
    public let swapCommit: String?

    enum CodingKeys: String, CodingKey {
        case repositoryDID = "repo"
        case collection
        case recordKey = "rkey"
        case shouldValidate = "validate"
        case record
        case swapCommit
    }
}
