//
//  AtprotoSyncGetBlocks.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-12.
//

import Foundation

/// The main data model definition for the output of getting a repository's blocks.
///
/// - Note: According to the AT Protocol specifications: "Get data blocks from a given repo, by
/// CID. For example, intermediate MST nodes, or records. Does not require auth; implemented
/// by PDS."
///
/// - SeeAlso: This is based on the [`com.atproto.sync.getBlocks`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/getBlocks.json
public struct SyncGetBlocksOutput: Codable {
    /// The decentralized identifier (DID) of the repository.
    public let repositoryDID: String
    /// An array of CID hashes from the repository.
    public let repositoryCIDHashes: [String]

    enum CodingKeys: String, CodingKey {
        case repositoryDID = "did"
        case repositoryCIDHashes = "cids"
    }
}
