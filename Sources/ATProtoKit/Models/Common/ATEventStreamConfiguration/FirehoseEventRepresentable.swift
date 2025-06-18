//
//  FirehoseEventRepresentable.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-17.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A protocol used for the basic skeleton of the model definitions.
public protocol FirehoseEventRepresentable: Decodable {

    /// Represents the stream sequence number of this message.
    ///
    /// - Note: According to the AT Protocol specifications: "The stream sequence number of
    /// this message."
    var sequence: Int? { get }
}

// MARK: - #commit
/// A data model definition for a repository state change.
///
/// - Note: According to the AT Protocol specifications: "Represents an update of repository state.
/// Note that empty commits are allowed, which include no repo data changes, but an update to rev
/// and signature."
///
/// - SeeAlso: This is based on the [`com.atproto.sync.subscribeRepos`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/subscribeRepos.json
public struct FirehoseFrameCommitMessage: Decodable {

    /// Represents the stream sequence number of this message.
    ///
    /// - Note: According to the AT Protocol specifications: "The stream sequence number of
    /// this message."
    public let sequence: Int

    /// Indicates that this commit contained too many operations, or the data size was too large.
    ///
    /// If this value is true, then a separate request will be needed to get the missing data.
    ///
    /// - Note: According to the AT Protocol specifications: "Indicates that this commit contained
    /// too many ops, or data size was too large. Consumers will need to make a separate request
    /// to get missing data."
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
    /// - Note: According to the AT Protocol specifications: "The rev of the emitted commit.
    /// Note that this information is also in the commit object included in blocks, unless this is
    /// a tooBig event."
    public let revision: String

    /// The revision of the last commit from the repository.
    ///
    /// - Note: According to the AT Protocol specifications: "The rev of the last emitted commit
    /// from this repo (if any)."
    public let since: String

    /// A .CAR file representing the changes in the repository state as a diff since the
    /// previous state.
    ///
    /// This is also in a DAG-CBOR format. This needs to be decoded separately.
    ///
    /// - Note: According to the AT Protocol specifications: "CAR file containing relevant
    /// blocks, as a diff since the previous repo state."
    public let blocks: Data

    /// An array of operations from the repository.
    ///
    /// - Note: According to the AT Protocol specifications: "List of repo mutation operations
    /// in this commit (eg, records created, updated, or deleted)."
    public let repositoryOperations: [FirehoseEventRepositoryOperation]

    /// An array of Content Identifiers (CIDs) that represent blobs.
    ///
    /// - Note: According to the AT Protocol specifications: "List of new blobs (by CID) referenced
    /// by records in this commit."
    public let blobIdentifiers: [String]

    /// The date and time the message was first broadcast.
    ///
    /// - Note: According to the AT Protocol specifications: "Timestamp of when this message
    /// was originally broadcast."
    public let timestamp: Date

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.sequence = try container.decode(Int.self, forKey: .sequence)
        self.isTooBig = try container.decode(Bool.self, forKey: .isTooBig)
        self.repository = try container.decode(String.self, forKey: .repository)
        self.commitCID = try container.decode(String.self, forKey: .commitCID)
        self.revision = try container.decode(String.self, forKey: .revision)
        self.since = try container.decode(String.self, forKey: .since)
        self.blocks = try container.decode(Data.self, forKey: .blocks)
        self.repositoryOperations = try container.decode([FirehoseEventRepositoryOperation].self, forKey: .repositoryOperations)
        self.blobIdentifiers = try container.decode([String].self, forKey: .blobIdentifiers)
        self.timestamp = try container.decodeDate(forKey: .timestamp)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.sequence, forKey: .sequence)
        try container.encode(self.isTooBig, forKey: .isTooBig)
        try container.encode(self.repository, forKey: .repository)
        try container.encode(self.commitCID, forKey: .commitCID)
        try container.encode(self.revision, forKey: .revision)
        try container.encode(self.since, forKey: .since)
        try container.encode(self.blocks, forKey: .blocks)
        try container.encode(blobIdentifiers, forKey: .blobIdentifiers)
        try container.encodeDate(self.timestamp, forKey: .timestamp)
    }

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
/// - Note: According to the AT Protocol specifications: "A repo operation, ie a mutation of a
/// single record."
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
    /// This property will have a value if ``action-swift.property`` is either `create`
    /// or `update`.
    ///
    /// - Note: According to the AT Protocol specifications: "For creates and updates, the new
    /// record CID. For deletions, null."
    public let recordCID: String?

    enum CodingKeys: String, CodingKey {
        case action = "action"
        case recordPath = "path"
        case recordCID = "cid"
    }

    // Enums
    public enum Action: String, Decodable {
        
        /// A "Create" action.
        case create
        
        /// An "Update" action.
        case update

        /// A "Delete" action.
        case delete
    }
}

// MARK: - #identity
/// A data model definition for an account identity change.
///
/// - Note: According to the AT Protocol specifications: "Represents a change to an account's
/// identity. Could be an updated handle, signing key, or pds hosting
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
    public let timestamp: Date

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.sequence = try container.decode(Int.self, forKey: .sequence)
        self.accountDID = try container.decode(String.self, forKey: .accountDID)
        self.timestamp = try container.decodeDate(forKey: .timestamp)
    }

    enum CodingKeys: String, CodingKey {
        case sequence = "seq"
        case accountDID = "did"
        case timestamp = "time"
    }
}

// MARK: - #handle
/// A data model definition for an account handle change state.
///
/// - Note: According to the AT Protocol specifications: "Represents an update of the account's
/// handle, or transition to/from invalid state. NOTE: Will be deprecated
/// in favor of #identity."
///
/// - SeeAlso: This is based on the [`com.atproto.sync.subscribeRepos`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/subscribeRepos.json
public struct FirehoseFrameHandleMessage: Decodable {

    /// Represents the stream sequence number of this message.
    public let sequence: Int

    /// The decentralized identifier (DID) of the account that has changed their handle.
    public let accountDID: String

    /// The account's new handle.
    public let newHandle: String

    /// The date and time the event was broadcast.
    public let timestamp: Date

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.sequence = try container.decode(Int.self, forKey: .sequence)
        self.accountDID = try container.decode(String.self, forKey: .accountDID)
        self.newHandle = try container.decode(String.self, forKey: .newHandle)
        self.timestamp = try container.decodeDate(forKey: .timestamp)
    }

    enum CodingKeys: String, CodingKey {
        case sequence = "seq"
        case accountDID = "did"
        case newHandle = "handle"
        case timestamp = "time"
    }
}

// MARK: - #migrate
/// A data model definition for an account migration event.
///
/// - Note: According to the AT Protocol specifications: "Represents an account moving from one
/// PDS instance to another. NOTE: not implemented; account migration
/// uses #identity instead"
///
/// - SeeAlso: This is based on the [`com.atproto.sync.subscribeRepos`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/subscribeRepos.json
public struct FirehoseFrameMigrateMessage: Decodable {

    /// Represents the stream sequence number of this message.
    public let sequence: Int

    /// The decentralized identifier (DID) of the account that's migrating.
    public let accountDID: String

    /// The target Personal Data Server (PDS) the account is migrating to. Optional.
    public let migrateTo: String?

    /// The date and time the event was broadcast.
    public let timestamp: Date

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.sequence = try container.decode(Int.self, forKey: .sequence)
        self.accountDID = try container.decode(String.self, forKey: .accountDID)
        self.migrateTo = try container.decodeIfPresent(String.self, forKey: .migrateTo)
        self.timestamp = try container.decodeDate(forKey: .timestamp)
    }

    enum CodingKeys: String, CodingKey {
        case sequence = "seq"
        case accountDID = "did"
        case migrateTo
        case timestamp = "time"
    }
}

// MARK: - #tombstone
/// A data model definition for an account deletion event.
///
/// - Note: According to the AT Protocol specifications: "Indicates that an account has been
/// deleted. NOTE: may be deprecated in favor of #identity or a future
/// #account event"
///
/// - SeeAlso: This is based on the [`com.atproto.sync.subscribeRepos`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/subscribeRepos.json
public struct FirehoseFrameTombstoneMessage: Decodable {

    /// Represents the stream sequence number of this message.
    public let sequence: Int

    /// The decentralized identifier (DID) of the account that has had their account deleted.
    public let accountDID: String

    /// The date and time the event was broadcast.
    public let timestamp: Date

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.sequence = try container.decode(Int.self, forKey: .sequence)
        self.accountDID = try container.decode(String.self, forKey: .accountDID)
        self.timestamp = try container.decodeDate(forKey: .timestamp)
    }

    enum CodingKeys: String, CodingKey {
        case sequence = "seq"
        case accountDID = "did"
        case timestamp = "time"
    }
}

// MARK: - #info
/// A data model definition for an information state.
///
/// - SeeAlso: This is based on the [`com.atproto.sync.subscribeRepos`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/subscribeRepos.json
public struct FirehoseFrameInfoMessage: Decodable {

    /// The name of the event state.
    public let eventName: EventName

    /// The message of the event.
    public let message: String

    enum CodingKeys: String, CodingKey {
        case eventName = "name"
        case message
    }

    // Enums
    /// An event state.
    public enum EventName: String, Decodable {

        /// An outdated cursor.
        case outdatedCursor = "OutdatedCursor"
    }
}

// MARK: - Union type
/// A reference containing the list of event messages.
public enum FirehoseFrameMessageUnion: Decodable {

    /// A "commit" event message.
    case commit(FirehoseFrameCommitMessage)

    /// An "identity" event message.
    case identity(FirehoseFrameIdentityMessage)

    /// A "handle" event message.
    case handle(FirehoseFrameHandleMessage)

    /// A "migrate" event message.
    case migrate(FirehoseFrameMigrateMessage)

    /// A "tombstone" event message.
    case tombstone(FirehoseFrameTombstoneMessage)

    /// An "info" event message.
    case info(FirehoseFrameInfoMessage)

    /// An "error" event message.
    case error(WebSocketFrameMessageError)

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(FirehoseFrameCommitMessage.self) {
            self = .commit(value)
        } else if let value = try? container.decode(FirehoseFrameIdentityMessage.self) {
            self = .identity(value)
        } else if let value = try? container.decode(FirehoseFrameHandleMessage.self) {
            self = .handle(value)
        } else if let value = try? container.decode(FirehoseFrameMigrateMessage.self) {
            self = .migrate(value)
        } else if let value = try? container.decode(FirehoseFrameTombstoneMessage.self) {
            self = .tombstone(value)
        } else if let value = try? container.decode(FirehoseFrameInfoMessage.self) {
            self = .info(value)
        } else if let value = try? container.decode(WebSocketFrameMessageError.self) {
            self = .error(value)
        } else {
            throw DecodingError.typeMismatch(
                FirehoseFrameMessageUnion.self, DecodingError.Context(
                    codingPath: decoder.codingPath, debugDescription: "Unknown FirehoseFrameMessageUnion type"))
        }
    }

    enum CodingKeys: CodingKey {
        case commit
        case identity
        case handle
        case migrate
        case tombstone
        case info
        case error
    }
}
