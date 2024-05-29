//
//  ComAtprotoRepoApplyWrites.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Repository {

    /// A request body model for applying batch CRUD transactions.
    ///
    /// - Note: According to the AT Protocol specifications: "Apply a batch transaction of
    /// repository creates, updates, and deletes. Requires auth, implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.applyWrites`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/applyWrites.json
    public struct ApplyWritesRequestBody: Codable {

        /// The decentralized identifier (DID) or handle of the repository.
        ///
        /// - Note: According to the AT Protocol specifications: "The handle or DID of the repo
        /// (aka, current account)."
        public let repositoryDID: String

        /// Indicates whether the operation should be validated. Optional. Defaults to `true`.
        ///
        /// - Note: According to the AT Protocol specifications: "Can be set to 'false' to skip
        /// Lexicon schema validation of record data, for all operations."
        public let shouldValidate: Bool?

        /// The write operation itself.
        public let writes: [ATUnion.ApplyWritesUnion]?

        /// Swaps out an operation based on the CID. Optional.
        ///
        /// - Important: If a value is entered in here, the entire operation will fail if there is
        /// no matching value in the repository.
        ///
        /// - Note: According to the AT Protocol specifications: "If provided, the entire operation
        /// will fail if the current repo commit CID does not match this value. Used to prevent
        /// conflicting repo mutations."
        public let swapCommit: String?

        enum CodingKeys: String, CodingKey {
            case repositoryDID = "repo"
            case shouldValidate = "validate"
            case writes
            case swapCommit
        }

        // Enums
        /// A data model definition for a "Create" write operation.
        ///
        /// - Note: According to the AT Protocol specifications: "Operation which creates a
        /// new record."
        ///
        /// - SeeAlso: This is based on the [`com.atproto.repo.applyWrites`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/applyWrites.json
        public struct Create: Codable {

            /// The NSID of the collection.
            public let collection: String

            /// The record key of the write operation. Optional.
            public let recordKey: String?

            /// The value of the write operation.
            public let value: UnknownType

            enum CodingKeys: String, CodingKey {
                case collection
                case recordKey = "rkey"
                case value
            }
        }

        /// A data model definition for an "Update" write operation.
        ///
        /// - Note: According to the AT Protocol specifications: "Operation which updates an
        /// existing record."
        ///
        /// - SeeAlso: This is based on the [`com.atproto.repo.applyWrites`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/applyWrites.json
        public struct Update: Codable {

            /// The NSID of the collection.
            public let collection: String

            /// The record key of the write operation.
            public let recordKey: String

            /// The value of the write operation.
            public let value: UnknownType

            enum CodingKeys: String, CodingKey {
                case collection
                case recordKey = "rkey"
                case value
            }
        }

        /// A data model definition for a "Delete" write operation.
        ///
        /// - Note: According to the AT Protocol specifications: "Operation which deletes an
        /// existing record."
        ///
        /// - SeeAlso: This is based on the [`com.atproto.repo.applyWrites`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/applyWrites.json
        public struct Delete: Codable {

            /// The NSID of the collection.
            public let collection: String

            /// The record key of the write operation.
            public let recordKey: String

            enum CodingKeys: String, CodingKey {
                case collection
                case recordKey = "rkey"
            }
        }
    }
}
