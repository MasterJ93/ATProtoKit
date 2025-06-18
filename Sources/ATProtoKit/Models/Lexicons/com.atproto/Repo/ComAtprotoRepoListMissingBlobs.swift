//
//  ComAtprotoRepoListMissingBlobs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Repository {

    /// The main data model for a record blob.
    public struct ListMissingBlobs: Sendable, Codable {

        /// A data model definition for a record blob.
        public struct RecordBlob: Sendable, Codable {

            /// The CID hash of the blob.
            public let blobCID: String

            /// The URI of the record.
            public let recordURI: String
        }
    }

    /// An output model for listing any missing blobs attached to the user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Returns a list of missing blobs for
    /// the requesting account. Intended to be used in the account migration flow."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.listMissingBlobs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/listMissingBlobs.json
    public struct ListMissingBlobsOutput: Sendable, Codable {

        /// An array of blobs.
        public let blobs: [ComAtprotoLexicon.Repository.ListMissingBlobs.RecordBlob]
    }
}
