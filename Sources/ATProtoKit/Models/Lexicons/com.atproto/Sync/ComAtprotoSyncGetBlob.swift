//
//  ComAtprotoSyncGetBlob.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Sync {

    /// A request body model for getting a blob.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a blob associated with a
    /// given account. Returns the full blob as originally uploaded. Does not require auth;
    /// implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.getBlob`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/getBlob.json
    public struct GetBlobOutput: Decodable {}
}
