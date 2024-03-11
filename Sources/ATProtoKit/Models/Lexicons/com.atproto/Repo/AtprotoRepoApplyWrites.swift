//
//  AtprotoRepoApplyWrites.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-11.
//

import Foundation

/// The main data model definition for applying batch CRUD transactions.
///
/// - Note: According to the AT Protocol specifications: "Apply a batch transaction of repository creates, updates, and deletes. Requires auth, implemented by PDS."
///
/// - SeeAlso: This is based on the [`com.atproto.repo.applyWrites`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/applyWrites.json
public struct RepoApplyWrites: Codable {
    /// The decentralized identifier (DID) or handle of the repository.
    ///
    /// - Note: According to the AT Protocol specifications: "The handle or DID of the repo (aka, current account)."
    public let repositoryDID: String
    /// Indicates whether the operation should be validated. Optional. Defaults to `true`.
    ///
    /// - Note: According to the AT Protocol specifications: "Can be set to 'false' to skip Lexicon schema validation of record data, for all operations."
    public let shouldValidate: Bool?
    /// The write operation itself.
    public let writes: [ApplyWritesUnion]?
    /// Swaps out an operation based on the CID. Optional.
    ///
    /// - Important: If a value is entered in here, the entire operation will fail if there is no matching value in the repository.
    ///
    /// - Note: According to the AT Protocol specifications: "If provided, the entire operation will fail if the current repo commit CID does not match this value.
    /// Used to prevent conflicting repo mutations."
    public let swapCommit: String?

    enum CodingKeys: String, CodingKey {
        case repositoryDID = "repo"
        case shouldValidate = "validate"
        case writes
        case swapCommit
    }
}

/// A data model definition for a "Create" write operation.
public struct RepoApplyWritesCreate: Codable {
    /// The NSID of the collection.
    public let collection: String
    /// The rKey of the write operation. Optional.
    public let rKey: String?
    /// The value of the write operation.
    public let value: UnknownType
}

/// A data model definition for an "Update" write operation.
public struct RepoApplyWritesUpdate: Codable {
    /// The NSID of the collection.
    public let collection: String
    /// The rKey of the write operation.
    public let rKey: String
    /// The value of the write operation.
    public let value: UnknownType
}

/// A data model definition for a "Delete" write operation.
public struct RepoApplyWritesDelete: Codable {
    /// The NSID of the collection.
    public let collection: String
    /// The rKey of the write operation.
    public let rKey: String
}

/// A reference containing the list of write operations.
public enum ApplyWritesUnion: Codable {
    /// A "Create" write operation.
    case create(RepoApplyWritesCreate)
    /// An "Update" write operation.
    case update(RepoApplyWritesUpdate)
    /// A "Delete" write operation.
    case delete(RepoApplyWritesDelete)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(RepoApplyWritesCreate.self) {
            self = .create(value)
        } else if let value = try? container.decode(RepoApplyWritesUpdate.self) {
            self = .update(value)
        } else if let value = try? container.decode(RepoApplyWritesDelete.self) {
            self = .delete(value)
        } else {
            throw DecodingError.typeMismatch(EmbedViewUnion.self,
                                             DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown ApplyWritesUnion type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .create(let embedView):
                try container.encode(embedView)
            case .update(let embedView):
                try container.encode(embedView)
            case .delete(let embedView):
                try container.encode(embedView)
        }
    }
}
