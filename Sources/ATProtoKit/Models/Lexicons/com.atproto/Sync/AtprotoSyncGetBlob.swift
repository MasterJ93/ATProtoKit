//
//  AtprotoSyncGetBlob.swift
//  
//
//  Created by Christopher Jr Riley on 2024-02-10.
//

import Foundation

// MARK: - Main definition
/// The main data model definition for getting a blob.
///
/// - Note: According to the AT Protocol specifications: "Get a blob associated with a
/// given account. Returns the full blob as originally uploaded. Does not require auth;
/// implemented by PDS."
///
/// - SeeAlso: This is based on the [`com.atproto.sync.getBlob`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/getBlob.json
public struct BlobQuery: Encodable {
    /// The decentralized identifier (DID) of the user's account.
    ///
    /// - Note: According to the AT Protocol specifications: "The DID of the account."
    public let accountDID: String
    /// The CID hash of the blob.
    ///
    /// - Note: According to the AT Protocol specifications: "The CID of the blob to fetch."
    /// - Note: Make sure to use `BlobReference.link` if you're grabbing it straight
    /// from ``UploadBlobOutput``.
    public let cidHash: String

    public init(accountDID: String, cidHash: String) {
        self.accountDID = accountDID
        self.cidHash = cidHash
    }
}
