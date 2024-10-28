//
//  ComAtprotoSyncGetBlocks.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Sync {

    /// The main data model definition for the output of getting a repository's blocks.
    ///
    /// - Note: According to the AT Protocol specifications: "Get data blocks from a given repo, by
    /// CID. For example, intermediate MST nodes, or records. Does not require auth; implemented
    /// by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.getBlocks`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/getBlocks.json
    public struct GetBlocksOutput: Sendable, Codable {}
}
