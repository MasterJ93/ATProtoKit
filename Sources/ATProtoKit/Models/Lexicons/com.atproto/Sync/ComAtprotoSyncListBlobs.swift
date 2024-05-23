//
//  ComAtprotoSyncListBlobs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Sync {

    /// An output model for a user account's blob CID hashes.
    ///
    /// - Note: According to the AT Protocol specifications: "List blob CIDs for an account, since
    /// some repo revision. Does not require auth; implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.listBlobs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/listBlobs.json
    public struct ListBlobsOutput: Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of CID hashes from a user account.
        public let accountCIDHashes: [String]

        enum CodingKeys: String, CodingKey {
            case cursor
            case accountCIDHashes = "cids"
        }
    }
}
