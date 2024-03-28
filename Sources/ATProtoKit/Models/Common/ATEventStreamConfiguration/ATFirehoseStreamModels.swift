//
//  ATFirehoseStreamModels.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-17.
//

import Foundation

/// A protocol used for the basic skeleton of the model definitions.
public protocol FirehoseEventRepresentable: Decodable {
    /// Represents the stream sequence number of this message.
    ///
    /// - Note: According to the AT Protocol specifications: "The stream sequence number of this message."
    var sequence: Int? { get }
    // TODO: Remove this.
    /// The date and time the object was sent to the stream.
    ///
    /// - Note: According to the AT Protocol specifications: "Timestamp of when this message was originally broadcast."
    var timeStamp: Date { get }
}

// MARK: - #Commit
/// A data model definition for a repository state change.
///
/// - Note: According to the AT Protocol specifications: "Represents an update of repository state. Note that empty commits are allowed, which include no repo data
/// changes, but an update to rev and signature."
///
/// - SeeAlso: This is based on the [`com.atproto.sync.subscribeRepos`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/subscribeRepos.json
public struct FirehoseFrameCommitMessage: Decodable {
    /// Represents the stream sequence number of this message.
    ///
    /// - Note: According to the AT Protocol specifications: "The stream sequence number of this message."
    public let sequence: String
    /// Indicates that this commit contained too many operations, or the data size was too large.
    ///
    /// If this value is true, then a separate request will be needed to get the missing data.
    ///
    /// - Note: According to the AT Protocol specifications: "Indicates that this commit contained too many ops, or data size was too large. Consumers will
    /// need to make a separate request to get missing data."
    public let isTooBig: Bool
    /// The repository from which this event originates.
    ///
    /// - Note: According to the AT Protocol specifications: "The repo this event comes from."
    public let repository: String
    /// The Content Identifier (CID) for the commit.
    ///
    /// - Note: According to the AT Protocol specifications: "Repo commit object CID."
    public let commitCID: String
    /// The revision of the commit.
    ///
    /// This information is duplicated in ``blocks``, unless ``isTooBig`` is set to `true`.
    ///
    /// - Note: According to the AT Protocol specifications: "The rev of the emitted commit. Note that this information is also in the commit object included in
    /// blocks, unless this is a tooBig event."
    public let revision: String
    /// The revision of the last commit from the repository.
    ///
    /// - Note: According to the AT Protocol specifications: "The rev of the last emitted commit from this repo (if any)."
    public let since: String
    /// A .CAR file representing the changes in the repository state as a diff since the previous state.
    ///
    /// This is also in a DAG-CBOR format. This needs to be decoded separately.
    ///
    /// - Note: According to the AT Protocol specifications: "CAR file containing relevant blocks, as a diff since the previous repo state."
    public let blocks: Data
    /// An array of operations from the repository.
    ///
    /// - Note: According to the AT Protocol specifications: "List of repo mutation operations in this commit (eg, records created, updated, or deleted)."
    public let repositoryOperations: [FirehoseEventRepositoryOperation]
    /// An array of Content Identifiers (CIDs) that represent blobs.
    ///
    /// - Note: According to the AT Protocol specifications: "List of new blobs (by CID) referenced by records in this commit."
    public let blobIdentifiers: [String]
    /// The date and time the message was first broadcast.
    ///
    /// - Note: According to the AT Protocol specifications: "Timestamp of when this message was originally broadcast."
    @DateFormatting public var timestamp: Date


    enum CodingKeys: String, CodingKey {
        case sequence = "seq"
        case isTooBig = "tooBig"
        case repository = "repo"
        case commitCID = "commit"
        case revision = "rev"
        case since
        case blocks
        case repositoryOperations = "ops"
        case blobIdentifiers = "blobs"
        case timestamp = "time"
    }
}

/// A data model definition for a repository operation.
///
/// - Note: According to the AT Protocol specifications: "A repo operation, ie a mutation of a single record."
///
/// - SeeAlso: This is based on the [`com.atproto.sync.subscribeRepos`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/subscribeRepos.json
public struct FirehoseEventRepositoryOperation: Decodable {
    /// The action given to the record.
    public let action: Action
    /// The path to the record.
    public let recordPath: String
    /// The Content Identifier (CID) of the record. Optional.
    ///
    /// This property will have a value if ``action-swift.property`` is either `create` or `update`.
    ///
    /// - Note: According to the AT Protocol specifications: "For creates and updates, the new record CID. For deletions, null."
    public let recordCID: String?

    enum CodingKeys: String, CodingKey {
        case action = "action"
        case recordPath = "path"
        case recordCID = "cid"
    }

    // Enums
    public enum Action: String, Decodable {
        case create
        case update
        case delete
    }
}

// MARK: - #Identity
/// A data model definition for an account identity change.
///
/// - Note: According to the AT Protocol specifications: "Represents a change to an account's identity. Could be an updated handle, signing key, or pds hosting
/// endpoint. Serves as a prod to all downstream services to refresh their identity cache."
///
/// - SeeAlso: This is based on the [`com.atproto.sync.subscribeRepos`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/subscribeRepos.json
public struct FirehoseFrameIdentityMessage: Decodable {
    /// Represents the stream sequence number of this message.
    public let sequence: Int
    /// The decentralized identifier (DID) of the account that has changed their identity.
    public let accountDID: String
    /// The date and time the event was broadcast.
    @DateFormatting public var timestamp: Date

    enum CodingKeys: String, CodingKey {
        case sequence = "seq"
        case accountDID = "did"
        case timestamp = "time"
    }
}
