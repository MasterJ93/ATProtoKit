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
    /// - Important: Current maximum length is 15 characters. This library will automatically truncate the `String` to the maximum length if it does go over the limit.
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

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.repositoryDID, forKey: .repositoryDID)
        try container.encode(self.collection, forKey: .collection)
        try truncatedEncodeIfPresent(self.recordKey, withContainer: &container, forKey: .recordKey, upToLength: 15)
        try container.encodeIfPresent(self.shouldValidate, forKey: .shouldValidate)
        try container.encode(self.record, forKey: .record)
        try container.encodeIfPresent(self.swapCommit, forKey: .swapCommit)
    }

    enum CodingKeys: String, CodingKey {
        case repositoryDID = "repo"
        case collection
        case recordKey = "rkey"
        case shouldValidate = "validate"
        case record
        case swapCommit
    }
}
