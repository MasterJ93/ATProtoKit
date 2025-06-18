//
//  ComAtprotoServerCheckAccountStatus.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Server {

    /// An output model for checking the user's account status.
    ///
    /// - Note: According to the AT Protocol specifications: "Returns the status of an account,
    /// especially as pertaining to import or recovery. Can be called many times over the course
    /// of an account migration. Requires auth and can only be called pertaining to oneself."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.checkAccountStatus`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/checkAccountStatus.json
    public struct CheckAccountStatusOutput: Sendable, Codable {

        /// Indicates whether the user's account has been activated.
        public let isActivated: Bool

        /// Indicates whether the user's account has a valid decentralized identifier (DID).
        public let isValidDID: Bool

        /// The current commit of the account.
        public let repositoryCommit: String

        /// The current revision of the account.
        public let repositoryRev: String

        /// The number of blocks in the account.
        public let repositoryBlocks: Int

        /// The number of indexed records in the user's account.
        public let indexedRecords: Int

        /// The number of private state values of the account.
        public let privateStateValues: Int

        /// The expected number of blobs in the user's account.
        public let expectedBlobs: Int

        /// The number of blobs imported into the user's account.
        public let importedBlobs: Int

        enum CodingKeys: String, CodingKey {
            case isActivated = "activated"
            case isValidDID = "validDid"
            case repositoryCommit = "repoCommit"
            case repositoryRev = "repoRev"
            case repositoryBlocks = "repoBlocks"
            case indexedRecords
            case privateStateValues
            case expectedBlobs
            case importedBlobs
        }
    }
}
