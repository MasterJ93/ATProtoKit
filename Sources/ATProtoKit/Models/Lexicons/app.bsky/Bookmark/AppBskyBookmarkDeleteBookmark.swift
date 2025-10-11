//
//  AppBskyBookmarkDeleteBookmark.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-09-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Bookmark {

    /// A request body model for deleting a private bookmark for the specified record.
    ///
    /// - Note: According to the AT Protocol specifications: "Deletes a private bookmark for the
    /// specified record. Currently, only `app.bsky.feed.post` records are supported.
    /// Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.bookmark.deleteBookmark`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/bookmark/deleteBookmark.json
    public struct DeleteBookmarkRequestBody: Sendable, Codable {

        /// The URI of the bookmark to delete.
        public let uri: String
    }
}
