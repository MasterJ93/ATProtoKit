//
//  ComAtprotoSyncGetRepoStatus.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Sync {

    /// The main data model definition for getting the status for a repository in the
    /// Personal Data Server (PDS).
    ///
    /// - Note: According to the AT Protocol specifications: "Get the hosting status for a
    /// repository, on this server. Expected to be implemented by PDS and Relay."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.getRepoStatus`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/getRepoStatus.json
    public struct GetRepositoryStatus: Sendable, Codable {

        /// The status of the repository.
        public enum Status: String, Sendable, Codable {

            /// Indicates the repository has been taken down.
            case takedown

            /// Indicates the repository has been suspended.
            case suspended

            /// Indicates the repository has been deactivated.
            case deactivated
        }
    }

    /// An output model for getting the status for a repository in the Personal Data Server (PDS).
    ///
    /// - Note: According to the AT Protocol specifications: "Get the hosting status for a
    /// repository, on this server. Expected to be implemented by PDS and Relay."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.getRepoStatus`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/getRepoStatus.json
    public struct GetRepositoryStatusOutput: Sendable, Codable {

        /// The decentralized identifier (DID) of the repository.
        public let repositoryDID: String

        /// Indicates whether the repository is active.
        public let isActive: Bool

        /// The status of the repository. Optional.
        public let status: GetRepositoryStatus.Status?

        /// The revision of the repository. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional field, the current rev
        /// of the repo, if active=true"
        public let revision: String?

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.repositoryDID = try container.decode(String.self, forKey: CodingKeys.repositoryDID)
            self.isActive = try container.decode(Bool.self, forKey: CodingKeys.isActive)
            self.status = try container.decodeIfPresent(ComAtprotoLexicon.Sync.GetRepositoryStatus.Status.self, forKey: CodingKeys.status)
            self.revision = try container.decodeIfPresent(String.self, forKey: CodingKeys.revision)
        }
        
        enum CodingKeys: String, CodingKey {
            case repositoryDID = "did"
            case isActive = "active"
            case status
            case revision = "rev"
        }
    }
}
