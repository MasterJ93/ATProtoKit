//
//  ComAtprotoSyncListReposByCollection.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-20.
//

import Foundation

extension ComAtprotoLexicon.Sync {

    /// A definition model for enumerating all decentralized identifiers (DIDs) with records
    /// in the given collection's Namespace Identifier (NSID).
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates all the DIDs which have
    /// records with the given collection NSID."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.listReposByCollection`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/listReposByCollection.json
    public struct ListRepositoriesByCollection: Sendable, Codable {

        /// A repository.
        public struct Repository: Sendable, Codable {

            /// The decentralized identifier of the repository.
            public let did: String
        }
    }

    /// An output model for enumerating all decentralized identifiers (DIDs) with records
    /// in the given collection's Namespace Identifiers (NSID).
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates all the DIDs which have
    /// records with the given collection NSID."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.listReposByCollection`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/listReposByCollection.json
    public struct ListRepositoriesByCollectionOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of repositories.
        public let repositories: [ListRepositoriesByCollection.Repository]
    }
}
