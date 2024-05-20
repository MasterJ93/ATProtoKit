//
//  ComAtprotoRepoDescribeRepo.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Repository {

    /// The main data model definition for the output of describing the repository.
    ///
    /// - Note: According to the AT Protocol specifications: "Get information about an account
    /// and repository, including the list of collections. Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.describeRepo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/describeRepo.json
    public struct DescribeRepositoryOutput: Codable {

        /// The handle of the repository.
        public let repositoryHandle: String

        /// The decentralized identitifer (DID) of the repository.
        public let repositoryDID: String

        /// The DID Document of the repository.
        ///
        /// - Note: According to the AT Protocol specifications: "The complete DID document for
        /// this account."
        public let didDocument: DIDDocument

        /// An array of collections related to the repository.
        ///
        /// - Note: According to the AT Protocol specifications: "List of all the collections
        /// (NSIDs) for which this repo contains at least one record."
        public let collections: [String]

        /// Indicates whether the repository's handle is valid.
        ///
        /// - Note: According to the AT Protocol specifications: "Indicates if handle is currently
        /// valid (resolves bi-directionally)."
        public let isHandleCorrect: Bool

        enum CodingKeys: String, CodingKey {
            case repositoryHandle = "handle"
            case repositoryDID = "did"
            case didDocument = "didDoc"
            case collections
            case isHandleCorrect = "handleIsCorrect"
        }
    }
}
