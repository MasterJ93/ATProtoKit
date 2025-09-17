//
//  ComAtprotoRepoCreateRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Repository {

    /// A request body model for creating a record.
    ///
    /// - Note: According to the AT Protocol specifications: "Create a single new repository record
    ///  Requires auth, implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.createRecord`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/createRecord.json
    public struct CreateRecordRequestBody: Sendable, Codable {

        /// The decentralized identifier (DID) or handle of the user account.
        ///
        /// - Note: According to the AT Protocol specifications: "The handle or DID of the repo
        /// (aka, current account)."
        public let repositoryDID: String

        /// The NSID of the record.
        ///
        /// - Note: According to the AT Protocol specifications: "The NSID of the record collection."
        public let collection: String

        /// The record key of the collection. Optional.
        ///
        /// - Important: Current maximum length is 512 characters.
        ///
        /// - Note: According to the AT Protocol specifications: "The Record Key."
        public let recordKey: String?

        /// Indicates whether the record should be validated. Optional. Defaults to `true`.
        ///
        /// - Note: According to the AT Protocol specifications: "Can be set to 'false' to skip
        /// Lexicon schema validation of record data, 'true' to require it, or leave unset to
        /// validate only for known Lexicons."
        public let shouldValidate: Bool?

        /// The record itself.
        public let record: UnknownType

        /// Swaps out an operation based on the CID. Optional.
        ///
        /// - Important: If a value is entered in here, the entire operation will fail if there is no
        /// matching value in the repository.
        ///
        /// - Note: According to the AT Protocol specifications: "Compare and swap with the previous
        /// commit by CID."
        public let swapCommit: String?

        public init(repositoryDID: String, collection: String, recordKey: String? = nil, shouldValidate: Bool? = nil, record: UnknownType, swapCommit: String? = nil) {
            self.repositoryDID = repositoryDID
            self.collection = collection
            self.recordKey = recordKey
            self.shouldValidate = shouldValidate
            self.record = record
            self.swapCommit = swapCommit
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.repositoryDID, forKey: .repositoryDID)
            try container.encode(self.collection, forKey: .collection)
            try container.truncatedEncodeIfPresent(self.recordKey, forKey: .recordKey, upToCharacterLength: 512)
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

    /// A output model for creating a record.
    ///
    /// - Note: According to the AT Protocol specifications: "Create a single new repository record
    ///  Requires auth, implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.createRecord`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/createRecord.json
    public struct CreateRecordOutput: Sendable, Codable {

        /// The URI of the record.
        public let uri: String

        /// The CID of the record.
        public let cid: String

        /// The commit of the record. Optional.
        public let commit: ComAtprotoLexicon.Repository.CommitMetaDefinition?

        /// The status of the write operation's validation. Optional.
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
