//
//  ComAtprotoSyncGetLatestCommit.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Sync {

    /// An output model for getting a repository's latest commit CID.
    ///
    /// - Note: According to the AT Protocol specifications: "Get the current commit CID & revision
    /// of the specified repo. Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.getLatestCommit`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/getLatestCommit.json
    public struct GetLatestCommitOutput: Sendable, Codable {

        /// The commit CID of the repository.
        public let cid: String

        /// The repository's revision.
        public let revision: String

        enum CodingKeys: String, CodingKey {
            case cid
            case revision = "rev"
        }
    }
}
