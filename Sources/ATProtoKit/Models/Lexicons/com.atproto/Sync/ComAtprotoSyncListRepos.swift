//
//  ComAtprotoSyncListRepos.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Sync {

    /// A definition model for isting all decentralized identifiers (DIDs), revisions, and
    /// commit CID hashes of given repositiories.
    public struct ListRepositories: Sendable, Codable {

        /// Indicates the status of the user account if it's inactivate.
        ///
        /// - Note: According to the AT Protocol specifications: "If active=false, this optional
        /// field indicates a possible reason for why the account is not active. If active=false
        /// and no status is supplied, then the host makes no claim for why the repository is no
        /// longer being hosted."
        public enum UserAccountStatus: String, Sendable, Codable {

            /// Indicates the user account is inactive due to a takedown.
            case takedown

            /// Indicates the repository has been suspended.
            case suspended

            /// Indicates the repository has been deleted.
            case deleted

            /// Indicates the repository has been deactivated.
            case deactivated

            /// Indicates the repository has been desynchronized.
            case desynchronized

            /// Indicates the repository has been throttled.
            case throttled
        }
    }

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
    public struct ListRepositoriesOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of repositories.
        public let repositories: [Repository]

        enum CodingKeys: String, CodingKey {
            case cursor
            case repositories = "repos"
        }

        // Enums
        /// A data model definition for a repository.
        public struct Repository: Sendable, Codable {

            /// The decentralized identifier (DID) of the repository.
            public let repositoryDID: String

            /// The commit CID hash of the repository.
            ///
            /// - Note: According to the AT Protocol specifications: "Current repo commit CID."
            public let commitCID: String

            /// The repository's revision.
            public let revision: String

            /// Indicates whether the repository is active. Optional.
            public let isActive: Bool?

            /// The status of the repository. Optional.
            public let status: ListRepositories.UserAccountStatus?

            enum CodingKeys: String, CodingKey {
                case repositoryDID = "did"
                case commitCID = "head"
                case revision = "rev"
                case isActive = "active"
                case status
            }
        }
    }
}
