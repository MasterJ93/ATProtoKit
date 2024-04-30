//
//  AtprotoRepoDeleteRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-11.
//

import Foundation

/// The main data model definition for deleting a record.
///
/// - Note: According to the AT Protocol specifications: "Delete a repository record, or ensure it
/// doesn't exist. Requires auth, implemented by PDS."
///
/// - SeeAlso: This is based on the [`com.atproto.repo.deleteRecord`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/deleteRecord.json
public struct RepoDeleteRecord: Codable {
    /// The decentralized identifier (DID) or handle of the user account.
    ///
    /// - Note: According to the AT Protocol specifications: "The handle or DID of the repo
    /// (aka, current account)."
    public let repositoryDID: String
    /// The NSID of the record.
    ///
    /// - Note: According to the AT Protocol specifications: "The NSID of the record collection."
    public let collection: String
    /// The record key of the record.
    ///
    /// - Note: According to the AT Protocol specifications: "The Record Key."
    public let recordKey: String
    /// Swap the record on the server with this current record based on the CID of the record on
    /// the server.
    ///
    /// - Note: According to the AT Protocol specifications: "Compare and swap with the
    /// previous record by CID."
    public let swapRecord: String?
    /// Swap the commit on the server with this current commit based on the CID of the commit
    /// on the server.
    ///
    /// - Note: According to the AT Protocol specifications: "Compare and swap with the
    /// previous commit by CID."
    public let swapCommit: String?

    enum CodingKeys: String, CodingKey {
        case repositoryDID = "repo"
        case collection
        case recordKey = "rkey"
        case swapRecord
        case swapCommit
    }
}
