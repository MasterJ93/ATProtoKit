//
//  ComAtprotoRepoPutRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Repository {

    /// A request body model for creating a record that replaces a previous record.
    ///
    /// - Note: According to the AT Protocol specifications: "Write a repository record, creating
    /// or updating it as needed. Requires auth, implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.putRecord`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/putRecord.json
    public struct PutRecordRequestBody: Sendable, Codable {

        /// The decentralized identifier (DID) or handle of the repository.
        ///
        /// - Note: According to the AT Protocol specifications: "The handle or DID of the repo
        /// (aka, current account)."
        public let repository: String

        /// The NSID of the record.
        ///
        /// - Note: According to the AT Protocol specifications: "The NSID of the
        /// record collection."
        public let collection: String

        /// The record key of the collection.
        ///
        /// - Note: According to the AT Protocol specifications: "The Record Key."
        public let recordKey: String

        /// Indicates whether the record should be validated. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Can be set to 'false' to skip
        /// Lexicon schema validation of record data, 'true' to require it, or leave unset to
        /// validate only for known Lexicons."
        public let shouldValidate: Bool?

        /// The record itself.
        ///
        /// - Note: According to the AT Protocol specifications: "The record to write."
        public let record: UnknownType

        /// Swaps the record in the server with the record contained in here. Optional.
        ///
        /// - Important: This field can be left blank.
        ///
        /// - Note: According to the AT Protocol specifications: "Compare and swap with the
        /// previous record by CID. WARNING: nullable and optional field; may cause problems
        /// with golang implementation"
        public let swapRecord: String?

        /// Swaps the commit in the server with the commit contained in here. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Compare and swap with the
        /// previous commit by CID."
        public let swapCommit: String?

        enum CodingKeys: String, CodingKey {
            case repository = "repo"
            case collection
            case recordKey = "rkey"
            case shouldValidate = "validate"
            case record
            case swapRecord
            case swapCommit
        }
    }

    /// A output model for creating a record that replaces a previous record.
    ///
    /// - Note: According to the AT Protocol specifications: "Write a repository record, creating
    /// or updating it as needed. Requires auth, implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.putRecord`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/putRecord.json
    public struct PutRecordOutput: Sendable, Codable {

        /// The URI of the record.
        public let uri: String

        /// The CID of the record.
        public let cid: String

        /// The commit of the record. Optional.
        public let commit: ComAtprotoLexicon.Repository.CommitMetaDefinition?

        /// The status of the write operation's validation.
        public let validationStatus: ValidationStatus?

        /// The status of the write operation's validation.
        public enum ValidationStatus: String, Sendable, Codable {

            /// Status is valid.
            case valid

            /// Status is unknown.
            case unknown
        }
    }
}
