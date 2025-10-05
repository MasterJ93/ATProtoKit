//
//  AppBskyBookmarkCreateBookmark.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-09-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Bookmark {

    /// A request body model for creating a private bookmark for the specified record.
    ///
    /// Currently limited to `app.bsky.feed.post` records.
    ///
    /// - Note: According to the AT Protocol specifications: "Creates a private bookmark for the
    /// specified record. Currently, only `app.bsky.feed.post` records are supported.
    /// Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.bookmark.createBookmark`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/bookmark/createBookmark.json
    public struct CreateBookmarkRequestBody: Sendable, Codable {

        /// The URI of the bookmark.
        public let uri: String

        /// The CID of the bookmark.
        public let cid: String

        public init(uri: String, cid: String) {
            self.uri = uri
            self.cid = cid
        }
    }
}
