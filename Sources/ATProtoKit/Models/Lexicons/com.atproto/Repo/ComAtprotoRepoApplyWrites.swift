//
//  ComAtprotoRepoApplyWrites.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Repository {

    /// The main data model definition for applying batch CRUD transactions.
    ///
    /// - Note: According to the AT Protocol specifications: "Apply a batch transaction of
    /// repository creates, updates, and deletes. Requires auth, implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.applyWrites`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/applyWrites.json
    public struct ApplyWrites: Sendable, Codable {

        /// A data model definition for a "Create" write operation.
        ///
        /// - Note: According to the AT Protocol specifications: "Operation which creates a
        /// new record."
        ///
        /// - SeeAlso: This is based on the [`com.atproto.repo.applyWrites`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/applyWrites.json
        public struct Create: Sendable, Codable {

            /// The NSID of the collection.
            public let collection: String

            /// The record key of the write operation. Optional.
            ///
            /// - Important: Current maximum length is 512 characters.
            ///
            /// - Note: According to the AT Protocol specifications: "NOTE: maxLength is redundant
            /// with record-key format. Keeping it temporarily to ensure backwards compatibility."
            public let recordKey: String?

            /// The value of the write operation.
            public let value: UnknownType

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(self.collection, forKey: .collection)
                try container.truncatedEncodeIfPresent(self.recordKey, forKey: .recordKey, upToCharacterLength: 512)
                try container.encode(self.value, forKey: .value)
            }

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
        public struct Update: Sendable, Codable {

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
        public struct Delete: Sendable, Codable {

            /// The NSID of the collection.
            public let collection: String

            /// The record key of the write operation.
            public let recordKey: String

            enum CodingKeys: String, CodingKey {
                case collection
                case recordKey = "rkey"
            }
        }

        /// A data model definition for a "Create" write operation result.
        ///
        /// - SeeAlso: This is based on the [`com.atproto.repo.applyWrites`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/applyWrites.json
        public struct CreateResult: Sendable, Codable {

            /// The URI of the result of the "Create" write operation.
            public let uri: String

            /// The CID of the result of the "Create" write operation.
            public let cid: String

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

        /// A data model definition for a "Update" write operation result.
        ///
        /// - SeeAlso: This is based on the [`com.atproto.repo.applyWrites`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/applyWrites.json
        public struct UpdateResult: Sendable, Codable {

            /// The URI of the result of the "Update" write operation.
            public let uri: String

            /// The CID of the result of the "Update" write operation.
            public let cid: String

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

        /// A data model definition for a "Delete" write operation result.
        ///
        /// - SeeAlso: This is based on the [`com.atproto.repo.applyWrites`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/applyWrites.json
        public struct DeleteResult: Sendable, Codable {}
    }

    /// A request body model for applying batch CRUD transactions.
    ///
    /// - Note: According to the AT Protocol specifications: "Apply a batch transaction of
    /// repository creates, updates, and deletes. Requires auth, implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.applyWrites`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/applyWrites.json
    public struct ApplyWritesRequestBody: Sendable, Codable {

        /// The decentralized identifier (DID) or handle of the repository.
        ///
        /// - Note: According to the AT Protocol specifications: "The handle or DID of the repo
        /// (aka, current account)."
        public let repositoryDID: String

        /// Indicates whether the operation should be validated. Optional. Defaults to `true`.
        ///
        /// - Note: According to the AT Protocol specifications: "Can be set to 'false' to skip
        /// Lexicon schema validation of record data across all operations, 'true' to require it,
        /// or leave unset to validate only for known Lexicons."
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
    }

    /// An output model for applying batch CRUD transactions.
    ///
    /// - Note: According to the AT Protocol specifications: "Apply a batch transaction of
    /// repository creates, updates, and deletes. Requires auth, implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.applyWrites`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/applyWrites.json
    public struct ApplyWritesOutput: Sendable, Codable {

        /// The commit of the writes. Optional.
        public let commit: ComAtprotoLexicon.Repository.CommitMetaDefinition?

        /// An array of results. Optional.
        public let results: [ATUnion.ApplyWritesResultUnion]?
    }
}

extension ATUnion {

    /// A reference containing the list of write operation results.
    public enum ApplyWritesResultUnion: Sendable, Codable {
        case createResult(ComAtprotoLexicon.Repository.ApplyWrites.CreateResult)
        case updateResult(ComAtprotoLexicon.Repository.ApplyWrites.UpdateResult)
        case deleteResult(ComAtprotoLexicon.Repository.ApplyWrites.DeleteResult)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ComAtprotoLexicon.Repository.ApplyWrites.CreateResult.self) {
                self = .createResult(value)
            } else if let value = try? container.decode(ComAtprotoLexicon.Repository.ApplyWrites.UpdateResult.self) {
                self = .updateResult(value)
            } else if let value = try? container.decode(ComAtprotoLexicon.Repository.ApplyWrites.DeleteResult.self) {
                self = .deleteResult(value)
            } else {
                throw DecodingError.typeMismatch(
                    ApplyWritesResultUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown ApplyWritesResultUnion value"))
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .createResult(let value):
                    try container.encode(value)
                case .updateResult(let value):
                    try container.encode(value)
                case .deleteResult(let value):
                    try container.encode(value)
            }
        }
    }
}
