//
//  AppBskyBookmarkGetBookmark.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-09-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Bookmark {

    /// An output model for retrieving a list of private bookmarks.
    ///
    /// - Note: According to the AT Protocol specifications: "Gets views of records bookmarked by the
    /// authenticated user. Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.bookmark.getBookmarks`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/bookmark/getBookmarks.json
    public struct GetBookmarksOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of bookmarks.
        public let bookmarks: [AppBskyLexicon.Bookmark.BookmarkViewDefinition]
    }
}
