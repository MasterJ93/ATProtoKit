//
//  ComAtprotoSyncListRepos.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Sync {

    /// An output model for isting all decentralized identifiers (DIDs), revisions, and
    /// commit CID hashes of given repositiories.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates all the DID, rev, and
    /// commit CID for all repos hosted by this service. Does not require auth;
    /// implemented by PDS and Relay."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.listRepos`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/listRepos.json
    public struct ListRepositoriesOutput: Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of repositories.
        public let repositories: [Repository]

        enum CodingKeys: String, CodingKey {
            case cursor
            case repositories = "repo"
        }

        // Enums
        /// A data model definition for a repository.
        public struct Repository: Codable {

            /// The decentralized identifier (DID) of the repository.
            public let repositoryDID: String

            /// The commit CID hash of the repository.
            ///
            /// - Note: According to the AT Protocol specifications: "Current repo commit CID."
            public let commitCID: String

            /// The repository's revision.
            public let revision: String

            enum CodingKeys: String, CodingKey {
                case repositoryDID = "did"
                case commitCID = "head"
                case revision = "rev"
            }
        }
    }
}
